data "http" "my_public_ip" {
  url = "https://ifconfig.co/json"
  request_headers = {
    Accept = "application/json"
  }
}

# Goal : Trying to get FreeTier AMI selected
# Result : Failed
# Why : There is no real way to select only the FreeTier AMI.#
# Explanation : The "aws_ami" is based on the command cli command : aws ec2 describe-images
#   e.g. : 
#      aws ec2 describe-images --owners=amazon --profile=terraform --filters Name=root-device-type,Values=ebs --filters Name=virtualization-type,Values=hvm
# 
# The above command returns an JSON object with multiple attribute but none of same say : "FreeTier". We can't know for sure all the images are FreeTier
# The only way to search is by knowing already the name of the AMI you want..
#
# I still implemented this functionality out of curiosity. It's good for personal AMI though.
data "aws_ami" "amzn2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-202*-x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

