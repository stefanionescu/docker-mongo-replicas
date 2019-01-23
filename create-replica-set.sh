function howManyServers {

  arg=''
  c=0
  for server in manager1 worker1 worker2
  do
      cmd='docker-machine ip '$server
      arg=$arg' --ad-host '${server}':'$($cmd)
  done

  echo $arg

}

function switchToServer {

  env='docker-machine env '$1
  echo '···························'
  echo '·· swtiching >>>> '$1' server ··'
  echo '···························'
  eval $($env)

}

function startReplicaSet {

  wait_for_database $2 "$4"
  docker exec -i $1 bash -c 'mongo --eval "rs.initiate() && rs.conf()" --port '$p' -u $MONGO_SUPER_ADMIN -p $MONGO_PASS_SUPER --authenticationDatabase="admin"'

}

function createDockerVolume {

  cmd=$(docker volume ls -q | grep $1)
  if [[ "$cmd" == $1 ]];

  then
    echo 'volume available'

  else
    cmd='docker volume create --name '$1
    eval $cmd

  fi

}

function copyFilesToContainer {
  echo '·· copying files to container >>>> '$1' ··'

  # copy necessary files
  docker cp ./admin.js $1:/data/admin/
  docker cp ./replica.js $1:/data/admin/
  docker cp ./mongo-keyfile $1:/data/keyfile/
  docker cp ./grantRole.js $1:/data/admin
  docker cp ./movies.js $1:/data/admin
}
