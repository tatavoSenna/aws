
# CREATE A SECUTITY GROUP ===================================================================
aws ec2 create-security-group --group-name CodeDeploy-Security-Group --description "For launching Windows Server images for use with AWS CodeDeploy"
aws ec2 authorize-security-group-ingress --group-name CodeDeploy-Security-Group --to-port 3389 --ip-protocol tcp --cidr-ip 0.0.0.0/0 --from-port 3389
aws ec2 authorize-security-group-ingress --group-name CodeDeploy-Security-Group --to-port 80 --ip-protocol tcp --cidr-ip 0.0.0.0/0 --from-port 80

# CREATE AN INSTANCE PROFILE FOR CODE DEPLOY ===================================================================

# create a IAM role for the ec2
aws iam create-role --role-name CodeDeploy-EC2 --assume-role-policy-document file://CodeDeploy-EC2-Trust.json ;

# attach a policy to the CodeDeploy-EC2 role
aws iam put-role-policy --role-name CodeDeploy-EC2 --policy-name CodeDeploy-EC2-Permissions --policy-document file://CodeDeploy-EC2-Permissions.json ;

# create an instance profile
aws iam create-instance-profile --instance-profile-name CodeDeploy-EC2-Instance-Profile;

# and attach it to the IAM role
aws iam add-role-to-instance-profile --instance-profile-name CodeDeploy-EC2-Instance-Profile --role-name CodeDeploy-EC2;


# RUN AN EC2 INSTANCE ============================================================================================

# run a ec2 instance
# ami-4d883350 - Ubuntu Server 14.04 LTS (HVM), EBS General Purpose (SSD) Volume Type.

aws ec2 run-instances \
  --image-id ami-4d883350 \
  --key-name tatavo_senna_sao_paulo \
  --user-data file://instance-setup.sh \
  --count 1 \
  --instance-type t2.micro \
  --iam-instance-profile Name=CodeDeploy-EC2-Instance-Profile
  --security-groups 

  # listar os ids das instancias rodando
  aws ec2 describe-instances \
  	--filters "Name=key-name,Values=tatavo_senna_sao_paulo" \
  	 --query "Reservations[*].Instances[*].[InstanceId]" \
  	 --output text

# CREATE AN DB INSTANCE ===========================================================================
aws rds create-db-instance \
  --db-name apliquei \
  --db-instance-identifier rds-apliquei \
  --allocated-storage 5 \
  --db-instance-class db.t1.micro \
  --engine postgres \
  --engine-version 9.4.1 \
  --master-username tatavo \
  --master-user-password gYWGvupc77Vvfx \
  --backup-retention-period 5 \
  --profile tatavo



















