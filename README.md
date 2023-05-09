# AWS R53 Domain IP refresh script

This is a simple bash script I've adapted from a solution on StackOverflow, which updates a hosted zones domain(s) class A record with the current public IP address.

I use crontab to run the script periodicly on my personal server since our ISP seems to randomly change the public IP address every few weeks and I suddenly lose access to my server! D:

### Usage 

Change the following vairables to reflect the parameters of your hosted zone. 

```
DOMAIN_NAME=YOUR DOMAIN
PUBLIC_RECORD=$DOMAIN_NAME
R53_HOSTED_ZONE=HOSTED ZONE
```

I would also recommend creating a new AWS user in a locked-down security group to reduce the likelyhood of somebody stealing your hosted zone ID and gaining root access.

### Crontab

To run the script periodicly with crontabm I would first recomend reading the documentation here. For my setup I have added the following line to my crontab file:

```
# Check for IP changes every 10 minutes
*/30 * * * * /home/felix/aws/domain_refresh.sh
```

Thank you to [Kaizen86](https://github.com/Kaizen86) for helping me with parsing the JSON output from aws! :D
