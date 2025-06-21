# Task 2: Basic Infrastructure Configuration

## VPC Configuration

- **Region**: us-east-1
- **Network**: 10.0.0.0/16

## Availability Zones

- us-east-1a
- us-east-1b

## Subnet Configuration

### Public Subnets

- us-east-1a: 10.0.1.0/24
- us-east-1b: 10.0.3.0/24

### Private Subnets

- us-east-1a: 10.0.2.0/24
- us-east-1b: 10.0.4.0/24

## Network Components

- **Internet Gateway**: For public subnets
- **NAT Gateway**: For private subnets internet access

## Bastion Host

- SSH access for specific IPs/CIDRs
- AWS Console Access

## Network ACL Rules

### Public NACL

#### Inbound Rules

- Rule 100: SSH (22) - Allow from 0.0.0.0/0
- Rule 200: HTTPS (443) - Allow from 0.0.0.0/0
- Rule 300: Ephemeral Ports (1024-65535) - Allow from 0.0.0.0/0
- Rule \*: All Traffic - Deny from 0.0.0.0/0

#### Outbound Rules

- Rule 200: All Traffic - Allow to 0.0.0.0/0
- Rule \*: All Traffic - Deny to 0.0.0.0/0

### Private NACL

#### Inbound Rules

- Rule 100: All Traffic - Allow from 10.0.0.0/16 (VPC internal)
- Rule \*: All Traffic - Deny from 0.0.0.0/0

#### Outbound Rules

- Rule 100: All Traffic - Allow to 10.0.0.0/16 (VPC internal)
- Rule \*: All Traffic - Deny to 0.0.0.0/0

## Security Groups

### Public Security Group

#### Inbound Rules

- HTTPS (443) - Allow from 0.0.0.0/0
- All Traffic - Allow from 10.0.0.0/16 (VPC internal)

#### Outbound Rules

- All Traffic - Allow to 0.0.0.0/0

### Private Security Group

#### Inbound Rules

- All Traffic - Allow from 10.0.0.0/16 (VPC internal)

#### Outbound Rules

- All Traffic - Allow to 10.0.0.0/16 (VPC internal)

### Bastion Security Group

#### Inbound Rules

- SSH (22) - Allow from your IP (specific IPs/CIDRs)
- SSH (22) - Allow from AWS EC2 Instance Connect
- All Traffic - Allow from 10.0.0.0/16 (VPC internal)

#### Outbound Rules

- All Traffic - Allow to 0.0.0.0/0
