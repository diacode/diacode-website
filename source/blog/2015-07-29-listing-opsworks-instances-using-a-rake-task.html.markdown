---
title: Listing OpsWorks instances using a rake task
date: 2015-07-29 13:44 UTC
author: Victor
tags:
  - rake
  - ruby
  - DevOps
  - Amazon Web Services
  - OpsWorks
excerpt: Handy rake task to get the IPs of your OpsWorks instances in a few lines of code with no need of using AWS web interface.
---

In Diacode we have moved most of our Rails projects to [AWS OpsWorks](http://aws.amazon.com/opsworks) which, quoting its website, is *an application management service that makes it easy to deploy and operate applications of all shapes and sizes*.

Despite some problems in the beginning due to our initial lack of experience with Chef we finally got used to it and right now we are pretty happy with the results.

Using load balancers or scaling your application with OpsWorks is really easy, you only need a few clicks to do it. However dealing with this kind of setup was a bit annoying when we wanted to gain SSH access to the instances since the IPs may change from time to time and that required us to go to the OpsWorks web interface everytime we needed the IP. As developers we are using the terminal most of the time and going from it to the browser and then back to the terminal is a big waste of time so it would be nice if we can do all steps from the console.

Fortunately AWS offers an API with its corresponding Ruby wrapper and it’s pretty straight forward solving this problem so let's add it to our Rails project:

```ruby
# Gemfile

group :development do 
  gem 'aws-sdk', '~> 2'
end
```

In second place we need an AWS user with the proper policy attached to retrieve this kind of information. We do this through AWS Identity and Access Management (IAM) web interface:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "opsworks:DescribeInstances",
        "opsworks:DescribeStackProvisioningParameters",
        "opsworks:DescribeStacks"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
```

Now that we have the proper policy attached we should add our aws **key** and **secret** to the project. By having `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables we can make aws-sdk work out of the box with no need of manual configuration. If you prefer a different approach you can get more information [here](http://docs.aws.amazon.com/sdkforruby/api/index.html#Configuration).

Last but not least the rake task which, as we said before, is pretty straight forward. In our case it was enough with listing our stacks, instances and their IPs but if you need to extend the functionality we recommend you to check out the [official documentation](http://docs.aws.amazon.com/sdkforruby/api/Aws/OpsWorks/Client.html) for `Aws::OpsWorks::Client` class. 

```ruby
# lib/tasks/opsworks.rake

namespace :opsworks do
  task instances: :environment do
    opsworks = Aws::OpsWorks::Client.new region: 'us-east-1'
    stacks_resp = opsworks.describe_stacks
    
    stacks_resp.stacks.each_with_index do |stack, idx|
      puts "#{stack.name}"
      puts "-" * stack.name.length

      instances_resp = opsworks.describe_instances(stack_id: stack.stack_id)
      
      instances_resp.instances.each do |instance|
        puts "#{instance.hostname} \t #{instance.public_ip}"
      end
    end
  end
end
```

This way we can have a more developer-friendly approach to get information about our AWS instances without having to touch the browser at all by just typing `rake opsworks:instances`.