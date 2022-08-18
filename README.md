# Automated Lamp Stack
Deploys a LAMP stack within AWS specifically designed for us-east-1

## General Architecture 
-  VPC containing two private and two public subnets along with a NAT and internet gateway.

- ASG running two instances split across AZs for high availabiltiy along

- Load balancer to route requests across both AZs. 

- RDS aurora-mysql cluster containing two instances for redundancy.

- S3 bucket for storing apache code; currently only uses custom index.php.

- Github workflow to oversee creation and updates.

- Workflow scripts to create all resources and perform updates.

## Getting Started

### Prerequisites
- Github account.
- AWS account with access to a user who can deploy cloudformation.
- Access and secrets keys for the AWS user.

### Manual steps
1. Create your own new github repository.
2. Clone this repository `git clone https://github.com/prehr/Automated_Lamp_AWS.git`
3. Perform the following commands to point the cloned project at your new repo:
```
git remote remove origin
git remote add origin <Your repo URL>
git branch -M main
git push -u origin main
```
4. Mimic the following secret within AWS Secrets Manager; this will be the password for the aurora-mysql admin. 
```
Secret name = rds/lamp/password
Secret key = lamp-rds-password
Secret value = {PICK A PASS}
```
5. Add AWS secrets to github; from your repo perform the following steps:
```
1. Open settings tab
2. Then select Secrects -> Actions -> New Secret
2. Repeat and add both AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY.
```

### Automation
- The `git push -u origin main` in step 3 above should've kicked off github workflow.
- You can check status via the actions tab on your github repo.


### Access
- Instance running apache can be access via SSM
- MYSQL database can be reached from the instances with something similar to the following:
```
mysql -h lamp-rds-cluster.cluster-xxxxxxxxx.us-east-1.rds.amazonaws.com -P 3306 -u admin -p

# The endpoint will need to be replaced with your writer instance endpoint; this can be found in the RDS console for your cluster.
```

### Future Improvements
- Implement some form of monitoring; i.e cloudwatch alerts, prometheus.
- CF improvements - health checks, conditionals for multiregion support.
- Better CI/CD (CodeDeploy, Jenkins) for the apache configs and php site code.
- Better cleanup on failures; if the github workflow fails stacks will remain created.