### Summary

This solution will build a k8s cluster in AWS, using kops. 
The example application has been built and pushed as a public image to Docker Hub, the k8s resources will be packaged and deployed using helm.


### What you'll need to run this
1. AWS account
2. AWS CLI with access configured to run with the default profile. Alternatively export AWS_PROFILE you'd prefer to use
3. AWS Hosted Zone under which record sets can be created for accessing the k8s cluster. 
   
   E.g.
   Hosted Zone:     mysubdomain.example.com
   Record Entries   k8s.mysubdomain.example.com
4. Configure `env.vars`
   
### DNS setup   

Note. The name servers listed in the child HostedZone (eg. mysubdomain.example.com) NS record , must be copied into the parent hosted zone (example.com) as an NS record entry

If this correct, running a dns lookup should return an `ANSWER SECTION` similar to this.
```bash
dig ns test.example.com
;; ANSWER SECTION:
test.example.com.	86399	IN	NS	ns-1190.awsdns-20.org.
test.example.com.	86399	IN	NS	ns-1770.awsdns-29.co.uk.
test.example.com.	86399	IN	NS	ns-386.awsdns-48.com.
test.example.com.	86399	IN	NS	ns-781.awsdns-33.net.
```

### s3 Bucket for Kops state 
Kops requires an s3 bucket for storing state, create one and add it to the `KOPS_STATE_STORE` environment variable in `env.vars`.
`aws s3api create-bucket --bucket <globally unique bucket name> --region eu-west-1`

### Spin Up

```bash
./up.sh
```

This may take around 5-10 mins. The DNS entry needs to propogate, the k8s controllers need to boot (i've set the instance size to t2.micro = slow boot times), and helm needs to install tiller.

### Test ()

```bash
./print.sh 100
```


### Tear down

```bash
./down.sh
```



### Docker Image CI

A docker image has been built in github/circleCI 
- circleci [jhuntoo/docker-devops-test-webapp](https://circleci.com/gh/jhuntoo/docker-devops-test-webapp)
- github [jhuntoo/docker-devops-test-webapp](https://github.com/jhuntoo/docker-devops-test-webapp)
