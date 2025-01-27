Terraform Deployment Guide
==========================

This guide provides step-by-step instructions to deploy the VPC, network components, and EC2 instances using GitHub Actions and Terraform.

Steps
-----

### 1\. Set Up Infrastructure

1.  **Navigate to GitHub Actions**:

    -   Go to the **Actions** tab in your GitHub repository.

2.  **Run the Workflow**:

    -   Execute the `.github/workflows/terraform.yml` workflow file.

3.  **Provide Parameters**:

    -   Input the required parameters as per the Terraform modules located in the `modules` directory.

### 2\. Key Files

-   `**main.tf**`: Contains the entire infrastructure configuration, including the VPC, subnets, NAT Gateway, route tables, security groups, and EC2 instances.

-   `**backend.tf**`: Configures the S3 backend for storing the Terraform state.

### 3\. Module Details

#### VPC Module

Defines the VPC and its subnets:

-   **VPC CIDR**: `10.0.0.0/16`

-   **Subnets**:

    -   Public subnets (`10.0.1.0/24`, `10.0.2.0/24`, `10.0.3.0/24`) across three availability zones.

    -   Private subnets (`10.0.4.0/24`, `10.0.5.0/24`, `10.0.6.0/24`) across three availability zones.

#### NAT Gateway Module

Sets up a NAT Gateway in the public subnet to enable internet access for private instances.

-   **NAT Gateway Name**: `prod-natgw`

-   **Subnet**: Public subnet `10.0.1.0/24` in `us-east-1a`.

#### Route Table Module

Configures public and private route tables:

-   **Public Route Table**:

    -   Routes internet traffic (`0.0.0.0/0`) to the internet gateway.

-   **Private Route Table**:

    -   Routes internet traffic (`0.0.0.0/0`) to the NAT Gateway.

#### Route Table Association Module

Associates subnets with the respective route tables:

-   Public subnets are associated with the public route table.

-   Private subnets are associated with the private route table.

#### Security Group Module

Defines the security group for EC2 instances:

-   **Ingress Rules**:

    -   Allow HTTP (`80/tcp`) and HTTPS (`443/tcp`) traffic from anywhere (`0.0.0.0/0`).

-   **Egress Rules**:

    -   Allow all outbound traffic (`-1` protocol).

#### EC2 Instances

-   **Public Instance**:

    -   Name: `webserver`

    -   Subnet: Public subnet `10.0.1.0/24`

    -   Public IP: Enabled

    -   Security Group: Assigned from the security group module.

-   **Private Instance**:

    -   Name: `apiserver`

    -   Subnet: Private subnet `10.0.4.0/24`

    -   Public IP: Disabled

    -   Security Group: Assigned from the security group module.

### 4\. Configure Secrets

Ensure the following secrets are set up in your GitHub repository:

-   `**AWS_ACCESS_KEY_ID**`: AWS access key for authentication.

-   `**AWS_SECRET_ACCESS_KEY**`: AWS secret key for authentication.

### 5\. Deployment Outcome

The Terraform configuration will deploy:

-   **VPC**: Creates a Virtual Private Cloud.

-   **Subnets**:

    -   Public and private subnets across three availability zones.

-   **NAT Gateway**: Enables internet access for private subnets.

-   **Route Tables**: Configures routes for public and private subnets.

-   **Security Groups**: Manages inbound and outbound traffic.

-   **EC2 Instances**:

    -   Public-facing instance for web services.

    -   Private instance for backend services.

Once the workflow is successfully executed, the complete network infrastructure and EC2 instances will be deployed in your AWS environment.