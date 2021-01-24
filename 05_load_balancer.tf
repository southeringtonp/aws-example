
resource "aws_eip" "eip_lb" {
    vpc = true
    depends_on = [aws_internet_gateway.igw]
}

resource "aws_lb" "lb" {
    name = "lb"
    internal = false
    load_balancer_type = "application"

    security_groups = [aws_security_group.sgweb.id] #TODO: Separate security group
    subnets = [ aws_subnet.sub3.id, aws_subnet.sub4.id ]

    enable_deletion_protection = false
    tags = {
        Name = "Load Balancer"
    }
}

resource "aws_lb_listener" "listener80" {
    load_balancer_arn = aws_lb.lb.arn
    port = "80"
    protocol = "HTTP"

    default_action {
        type = "fixed-response"
        fixed_response {
            content_type = "text/plain"
            message_body = "This is a fixed response"   #TODO
            status_code = "200"
        }
    }
}


#TODO: S3 bucket with access logs
#TODO: Health Check
