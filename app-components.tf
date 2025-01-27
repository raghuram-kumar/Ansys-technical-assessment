module "natGw" {
  source = "./modules/vpc-components"
  vpcID  = module.vpc.vpcID
  natGateway = [{
    natGatewayName = "prod"
    subnetID       = module.vpc.subnetId[0]["public-subnet-01"]["id"]
  }]
  depends_on = [module.vpc]
}

module "rtb" {
  source = "./modules/vpc-components"
  vpcID  = module.vpc.vpcID
  routeTable = {
    "public-rtb" = {
      routes = [
        {
          cidrBlock = "0.0.0.0/0"
          gatewayId = module.vpc.igwID
        }
      ]
    },
    "private-rtb" = {
      routes = [
        {
          cidrBlock    = "0.0.0.0/0"
          natGatewayId = module.natGw.natGwID[0]["0"]["id"]
        }
      ]
    }
  }
  depends_on = [module.vpc, module.natGw]
}

module "rtbAssoc" {
  source = "./modules/vpc-components"
  rtbAssociation = [{
    routeTableID = module.rtb.rtbID[0]["private-rtb"]["id"]
    subnetID     = module.vpc.subnetId[0]["private-subnet-01"]["id"]
  },
  {
    routeTableID = module.rtb.rtbID[0]["private-rtb"]["id"]
    subnetID     = module.vpc.subnetId[0]["private-subnet-02"]["id"]
  },
  {
    routeTableID = module.rtb.rtbID[0]["private-rtb"]["id"]
    subnetID     = module.vpc.subnetId[0]["private-subnet-03"]["id"]
  },
  {
    routeTableID = module.rtb.rtbID[0]["public-rtb"]["id"]
    subnetID     = module.vpc.subnetId[0]["public-subnet-01"]["id"]
  },
    {
    routeTableID = module.rtb.rtbID[0]["public-rtb"]["id"]
    subnetID     = module.vpc.subnetId[0]["public-subnet-02"]["id"]
  },
    {
    routeTableID = module.rtb.rtbID[0]["public-rtb"]["id"]
    subnetID     = module.vpc.subnetId[0]["public-subnet-03"]["id"]
  }
  ]
  depends_on = [module.rtb]
}

module "ec2PublicInstance" {
  source           = "./modules/ec2"
  instanceName     = "webserver"
  instanceSubnetID = module.vpc.subnetId[0]["public-subnet-01"]["id"]
  enablePublicIP   = true
  sgList           = [module.sgGroup.sgID]
  ec2KeyName       = "prodkey"
  depends_on       = [module.sgGroup]
}

module "ec2PrivateInstance" {
  source           = "./modules/ec2"
  instanceName     = "apiserver"
  instanceSubnetID = module.vpc.subnetId[0]["private-subnet-01"]["id"]
  enablePublicIP   = false
  sgList           = [module.sgGroup.sgID]
  ec2KeyName       = "prodkey"
  depends_on       = [module.sgGroup]
}

module "vpc" {
  source  = "./modules/vpc"
  vpcCidr = "10.0.0.0/16"
  vpcName = "VPC-Prod"
  subnets = {
    "public-subnet-01" = {
      subnetCIDR = "10.0.1.0/24"
      az         = "us-east-1a"
    },
    "public-subnet-02" = {
      subnetCIDR = "10.0.2.0/24"
      az         = "us-east-1b"
    },
    "public-subnet-03" = {
      subnetCIDR = "10.0.3.0/24"
      az         = "us-east-1c"
    },
    "private-subnet-01" = {
      subnetCIDR = "10.0.4.0/24"
      az         = "us-east-1a"
    },
    "private-subnet-02" = {
      subnetCIDR = "10.0.5.0/24"
      az         = "us-east-1b"
    },
    "private-subnet-03" = {
      subnetCIDR = "10.0.6.0/24"
      az         = "us-east-1c"
    }
  }
}


module "sgGroup" {
  source        = "./modules/sg"
  sgName        = "EC2 SecurityGroup"
  sgDescription = "EC2 Specific Group"
  sgVPCID       = module.vpc.vpcID
  sgRulesIngress = [{
    cidr     = "0.0.0.0/0"
    fromPort = 80
    toPort   = 80
    protocol = "tcp"
    },
    {
      cidr     = "0.0.0.0/0"
      fromPort = 443
      toPort   = 443
      protocol = "tcp"
  }]
  sgRulesEgress = [{
    cidr     = "0.0.0.0/0"
    protocol = "-1"
  }]
  depends_on = [module.vpc]
}