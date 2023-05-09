# AWS R53 Domain IP refresh script

This is a simple bash script I've adapted from a solution on StackOverflow, which updates your R53's hosted zone domains class A record with the current public IP address.

I use crontab to run the script periodicly on my personal server since our ISP seems to randomly change the public IP address every few weeks and I suddenly lose access to my server! D:

### Usage 

Clone the github repo to and change the following vairables to reflect the parameters of your hosted zone. 

```
DOMAIN_NAME=YOUR DOMAIN

R53_HOSTED_ZONE=HOSTED ZONE
```

I would also recommend creating a new AWS user in a locked-down security group to reduce the vunrability of your hosted zone(s).

### Crontab

To run the script every 30mins with crontab I have added the following to my crontab file:

```
# Check for IP changes every 10 minutes
*/30 * * * * /PATHTOPARENTDIRECTORY/domain_refresh.sh
```
You can check crontab is working properly by using `$ cat /var/log/syslog | grep CRON`. Crontab wont immediatly run the script, so you may have to wait however long you've set the interval until you start seeing logs.

Thank you to [Kaizen86](https://github.com/Kaizen86) for helping me with parsing the JSON output from aws! :D
