# Automated Lamp Stack
Deploys a LAMP stack within AWS specifically designed for us-east-1.

## General Architecture 
- VPC containing two private and two public subnets along with a NAT and internet gateway.
- ASG running two instances split across AZs for high availabiltiy.
- Load balancer to route requests across both AZs. 
- RDS aurora-mysql cluster containing two instances for redundancy.
- S3 bucket for storing apache code; currently only uses a custom index.php.
- Github workflow to oversee LAMP creation and updates.
- Workflow scripts to create all resources and perform updates.

## Getting Started
### Prerequisites
- Github account.
- AWS account with access to a user who can deploy cloudformation.
- Access and secrets keys for that AWS user.

### Setup
1. Mimic the following secret within AWS Secrets Manager; this will be the password for the aurora-mysql admin. 
```
Secret name = rds/lamp/password
Secret key = lamp-rds-password
Secret value = {PICK A PASS}
```
2. Create your own new github repository.
3. Add AWS secrets to your new repo; from within the repo perform the following:
```
1. Open settings tab
2. Then select Secrects -> Actions -> New Secret
3. Repeat and add both AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY.
```
4. Clone this repository `git clone https://github.com/prehr/Automated_Lamp_AWS.git`
5. Run these commands to point the cloned project at your repo:
```
git remote remove origin
git remote add origin <Your repo URL>
git branch -M main
git push -u origin main

# Warning: once the push to main is done the github workflow will run and automation will take over.
```


## Automation
- The `git push -u origin main` in step 5 above should've kicked off github workflow; you can check status via the actions tab on your github repo.
- Once the github action completes verify the following stacks `lamp-vpc, lamp-app, lamp-rds` all exist in a CREATE_COMPLETE state.
- Once the above has been verified you should be able to access your LAMP stack.

## Access
- The webserver can be visited by using the loadbalancer DNS name. Landing page is a basic hello world app.
```
# Your DNS name be found on the load balancer ec2 page. ex:
lamp-Appli-11WJ4SEXULGN5-1303019156.us-east-1.elb.amazonaws.com
```
- Your instances running apache can be access via SSM; they can also be used to access the aurora-mysql database.
- The aurora-mysql database can be reached from the instances by running:
```
mysql -h lamp-rds-cluster.cluster-xxxxxxxxx.us-east-1.rds.amazonaws.com -P 3306 -u admin -p

# The endpoint will need to be replaced with your writer instance endpoint; this can be found in the RDS console for your cluster.
```

### Future Improvements
- Implement some form of monitoring; i.e cloudwatch alerts, prometheus.
- CF improvements - health checks, conditionals for multiregion support.
- Security improvements, maybe a WAF for implementing rules/limits.
- Better CI/CD (CodeDeploy, Jenkins) for the apache configs and php site code.
- Better cleanup on failures; if the github workflow fails stacks will remain created.