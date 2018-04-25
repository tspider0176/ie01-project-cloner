## IE1 Corrector
m5211143 Tomohiro Saito

Simple project cloning tool for IE01 class

### env
```
$ ruby -v  
~> ruby 2.2.3 p173  

$ curl --version  
~> curl 7.43.0 (x86_64-apple-darwin15.0)  

$ git --verison  
~> git 2.6.0
```

### preparing
- Establish GitHub ssh authorization  
due to clone process through ssh_url
- Get GitHub access token  

Get your personal token at [tokens page](https://github.com/settings/tokens) and paste TOKEN file on project root.

```sh
$ cd ./ie03-corrector
$ touch TOKEN
$ echo "[your token]" > TOKEN
```

### run
#### 1st time

```sh
$ ruby corrector.rb [csv file from mailing list] [classroom_roster.csv file from GitHub classroom page]
```

example:
```sh
$ ruby corrector.rb 11-3002-IE03-std5.csv classroom_roster.csv
```

#### from the 2nd time

```sh
ruby corrector.rb
```

Then automatically clone all repositories according to json files which had corrected last time.
