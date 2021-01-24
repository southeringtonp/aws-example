
resource "aws_eip" "eip_lb" {
    vpc = true
    depends_on = [aws_internet_gateway.igw]
}

resource "aws_lb" "lb" {
    name = "lb"
    internal = false
    load_balancer_type = "application"

    security_groups = [aws_security_group.sgweb.id] #TODO: Separate security group
    subnets = [ aws_subnet.sub1.id, aws_subnet.sub2.id ]

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
        type = "forward"
        target_group_arn = aws_lb_target_group.lbtarget.arn
    }


#    default_action {
#        type = "fixed-response"
#        fixed_response {
#            content_type = "text/plain"
#            message_body = "The internal server is not available."
#            status_code = "503"
#        }
#    }
}

resource "aws_lb_target_group" "lbtarget" {
    vpc_id = aws_vpc.vpc1.id
    
    port = 80
    protocol = "HTTP"
    load_balancing_algorithm_type = "round_robin"

    target_type = "instance"
    
#    health_check {
#        enabled = "true"
#        path = "/"
#        matcher = "200"
#    }
}

resource "aws_lb_target_group_attachment" "backend" {
    target_group_arn = aws_lb_target_group.lbtarget.arn
    target_id = aws_instance.compute3.id
}

#resource "aws_lb_listener_rule" "static" {
#    listener_arn = aws_lb_listener.listener80.arn
#    priority = 100
#
#    action {
#        type = "forward"
#        target_group_arn = aws_lb_target_group.lbtarget.arn
#    }
#    condition {
#        path_pattern {
#            values = ["/*"]
#        }
#    }
#}




#TODO: S3 bucket with access logs
#TODO: Health Check
