#!/bin/bash

app_name=${app_name:""}

check_app_name(){
    #check to see if app name
    if [ -z "$app_name" ]
    then
        echo "You must inform app_name"
        exit 0
    else
        echo "\$app_name\t $app_name"
    fi
}
check_dumpdata(){
    # check to see if must dump data
    if [ -z ${dumpdata+x} ]
    then
        #if not setted
        echo "";
    else
        if [ -z ${dumpdata} ]
        then
            echo "You must set a file to export";
            echo "$0 --dumpdata backup.json";
            exit 0
        else
            python manage.py dumpdata "$app_name" > "$dumpdata";
        fi
    fi
}
check_resetDB(){
    # check to see if must dump data
    if [ -z ${resetDB+x} ]
    then
        #if not setted
        echo "";
    else
        if [ -z ${resetDB} ]
        then
            find . -path "*/migrations/*.py" -not -name "__init__.py" -delete
            find . -path "*/migrations/*.pyc"  -delete
            rm db.sqlite3
            python manage.py makemigrations
            python manage.py migrate
        else
            echo "";
        fi
    fi
}
while [ $# -gt 0 ]; do
    if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
        # echo $1 $2 // Optional to see the parameter:value result
    fi
    shift
done

check_dumpdata
check_resetDB
