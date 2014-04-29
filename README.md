# XIMS PLATFORM
This repo only contains the backend of the platform, which has only API's and
do not render any html.

To see the web client app see:
[xims-web](https://github.com/chris-ramon/xims-web)

## About xims-platform
xims-platform is a safety risk management software, that allows companies, smartly manage: incidents, corrective actions and trainings in order to make better decisions and reduce incidents and accidents.

<hr>
![Alt](https://pbs.twimg.com/media/Blx2_MMCAAAl14_.png:large)

<hr>
![Alt](https://pbs.twimg.com/media/BmaSiPsCcAIO689.png:large)

<hr>
## Running
``` bash
rvm use ruby-2.0.0-p353@xims_demo --create --ruby-version
bundle install
rake db:migrate
rails s
```