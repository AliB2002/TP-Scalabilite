# Projet – Scalabilité

## Équipe

- Simon Rieira
- Wassim Bedidi
- Corane Ladjali
- Ali Boukkouri

## Plan de mise en œuvre

Dans le cadre de ce projet, nous allons mettre en place un système capable de s’adapter automatiquement à la charge, en créant ou supprimant des serveurs selon les besoins. Pour cela, nous utiliserons un **Auto Scaling Group (ASG)** sur AWS, associé à un **Application Load Balancer (ALB)**. Le système reposera sur une **AMI personnalisée** contenant une application web simple, comme un serveur Nginx ou une API Flask. L’ensemble sera automatisé avec **Terraform**, conformément aux bonnes pratiques de l’infrastructure as code.

La répartition des tâches dans l’équipe est la suivante :

- **Ali Boukkouri** se chargera de la création de l’AMI personnalisée contenant l’application à déployer, ainsi que de la configuration du script `user_data` pour l'installation automatique des services sur chaque instance lancée par l’ASG.

- **Simon Rieira** prendra en charge la mise en place du **Load Balancer**, du **Launch Template** et de la configuration de l’Auto Scaling Group, avec les règles de scaling basées sur l’utilisation CPU.

- **Wassim Bedidi** s’occupera de la configuration du réseau AWS avec **Terraform**, incluant le VPC, les sous-réseaux, les groupes de sécurité, et les rôles IAM nécessaires au bon fonctionnement du système.

- **Corane Ladjali** sera responsable de la mise en place de l’outil de **monitoring**, de la création des dashboards avec Grafana connecté à Grafana, ainsi que de la rédaction des tests de charge.

Une fois l’infrastructure déployée, nous simulerons une montée en charge en générant du trafic HTTP via l’instance bastion. Cela nous permettra de tester la réactivité du système et d’observer l’auto-scalabilité en action. Les performances seront visualisées dans un dashboard Grafana personnalisé, affichant notamment l’utilisation CPU, le nombre d’instances EC2 actives et la bande passante réseau.

Enfin, nous documenterons l’ensemble du projet dans un rapport structuré contenant :

- une description de l’architecture,
- la répartition des tâches,
- les captures d’écran des dashboards Grafana,
- les résultats des tests de charge,
- ainsi que le code Terraform complet versionné sur Git.

Tout le projet pourra être déployé de bout en bout avec une seule commande Terraform, démontrant ainsi notre capacité à construire une infrastructure scalable, automatisée et observable.

