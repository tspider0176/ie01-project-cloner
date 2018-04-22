## IE1 Corrector
m5211143 Tomohiro Saito

Simple project cloning tool for IE01 class

### env
ruby 2.2.3 p173
curl 7.43.0
git 2.6.0

### preparing
- Establish GitHub ssh authorization
- Get GitHub access token

### run
#### 1st time exec.

```sh
$ ruby corrector.rb [csv file from mailing list] [roster.csv file from GitHub classroom]
```

#### after 2nd time exec.

```sh
ruby corrector.rb
```
