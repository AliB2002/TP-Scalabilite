provider "aws" {
  alias  = "grafana"
  region = var.region
}

data "aws_instances" "grafana_asg_instances" {
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = [aws_autoscaling_group.asg.name]
  }
}

resource "null_resource" "grafana_datasource" {
  depends_on = [aws_lb.lb]

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command = <<EOF
    $uriCheck = "http://${aws_lb.lb.dns_name}:3000/login"
    $maxRetries = 20
    $retry = 0
    $success = $false

    while (-not $success -and $retry -lt $maxRetries) {
      try {
        $response = Invoke-WebRequest -Uri $uriCheck -UseBasicParsing -TimeoutSec 5
        if ($response.StatusCode -eq 200) {
          $success = $true
        } else {
          Start-Sleep -Seconds 10
          $retry++
        }
      } catch {
        Start-Sleep -Seconds 10
        $retry++
      }
    }

    if (-not $success) {
      Write-Error "Grafana n'est pas prêt après $maxRetries essais."
      exit 1
    }

    $headers = @{
      "Content-Type" = "application/json"
    }

    $body = @{
      name     = "CloudWatch"
      type     = "cloudwatch"
      access   = "proxy"
      jsonData = @{
        defaultRegion = "$env:AWS_REGION"
      }
    } | ConvertTo-Json -Depth 10

    $uri = "http://${aws_lb.lb.dns_name}:3000/api/datasources"
    Invoke-RestMethod -Method Post -Uri $uri -Headers $headers -Body $body
EOF
  }
}

resource "null_resource" "grafana_dashboard" {
  depends_on = [null_resource.grafana_datasource]

  triggers = {
    instances = join(",", data.aws_instances.grafana_asg_instances.ids)
  }

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command = <<EOF
$instances = "$${self.triggers.instances}".Split(',')
$alb_dns   = "${aws_lb.lb.dns_name}"
$x = 0; $y = 0

foreach ($instanceId in $instances) {
  $dashboard = @{
    dashboard = @{
      id     = $null
      uid    = "auto-$instanceId"
      title  = "EC2 Monitoring - $instanceId"
      panels = @(
        @{
          type       = "timeseries"
          title      = "CPU Utilization - $instanceId"
          datasource = "CloudWatch"
          targets    = @(
            @{
              refId      = "A$($instanceId.Replace('-',''))"
              namespace  = "AWS/EC2"
              metricName = "CPUUtilization"
              dimensions = @{ InstanceId = $instanceId }
              statistics = @("Average")
            }
          )
          gridPos = @{ h = 8; w = 12; x = ($x * 12); y = ($y * 16) }
        },
        @{
          type       = "timeseries"
          title      = "RAM Utilization - $instanceId"
          datasource = "CloudWatch"
          targets    = @(
            @{
              refId      = "B$($instanceId.Replace('-',''))"
              namespace  = "CWAgent"
              metricName = "mem_used_percent"
              dimensions = @{ InstanceId = $instanceId }
              statistics = @("Average")
            }
          )
          gridPos = @{ h = 8; w = 12; x = ($x * 12); y = (($y * 16) + 8) }
        }
      )
    }
  } | ConvertTo-Json -Depth 10

  $uri = "http://$alb_dns:3000/api/dashboards/db"
  Invoke-RestMethod -Method Post -Uri $uri -Headers @{
    "Content-Type" = "application/json"
  } -Body $dashboard

  $x++
  if ($x -ge 2) { $x = 0; $y++ }
}
EOF

  }
}
