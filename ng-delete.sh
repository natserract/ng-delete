
#!/bin/bash


printf "\n"

option_c=$1
component_name=$2

option_multiple=$3
multiple=$4

option_proj_type=$5
proj_type=$6

function raise_error(){
    local message=$1
    echo "$(tput setaf 1)$message"
}

function message_success(){
    local message=$1
    printf "\n"
    echo "$(tput setaf 2)$message"
    printf "\n"
}

function check_directory_is_present(){
    local path=($(ls -d $1 ))
    if [ ! -d "$path" ]; 
    then 
        return 1 
    else 
        return 0 
    fi
}

function delete_dir(){
    local dir_path=$1; 
    rm -rf $dir_path;
    
    message_success "Directory $dir_path succesfully deleted"
}

function arguments_error(){
    local args_err_message=$1
    echo "ngDelete: $args_err_message"; echo "usage: ngDelete [-cmt] [name ...]"
    break 
}

while [ -n "$1" ]; do
    case "$1" in
    -c) param="$1"
        
        if [ ! $# -gt 6 ];
        then
            if 
            [ -x $option_multiple ] &&
            [ -x $option_proj_type ]
            then 
                if check_directory_is_present src/app/$component_name
                then 
                    result_path=$( echo "src/app/$component_name" )
                    delete_dir $result_path
                else 
                    raise_error "Directory not found!"
                fi
            elif
            [ -x $option_proj_type ] ||
            [ -x $proj_type ]
            then
            arguments_error "Something's missing, check again"
            
            else
                if [ $proj_type == 'app' ] || [ $proj_type == 'lib' ]
                then 
                    if [ $proj_type == 'app' ]
                    then 
                    if check_directory_is_present projects/${multiple}/src/app/$component_name
                        then 
                            result_path=$( echo "projects/${multiple}/src/app/$component_name" )
                            delete_dir $result_path
                        else 
                            raise_error "Directory not found!"
                        fi
                    elif [ $proj_type == 'lib' ]
                    then
                        if check_directory_is_present projects/${multiple}/src/lib
                        then 
                            result_path=$( echo "projects/${multiple}/src/lib/$component_name" )
                            delete_dir $result_path
                        else 
                            raise_error "Directory not found!"
                        fi
                    fi
                else
                raise_error "Select multiple project types correctly! (app/lib)"
                fi
            fi
        else
            arguments_error "illegal option -- ${@:$#}" 
            break
        fi

        shift;; 
        

    -m) param="$2"
        shift;; 
        
    -t) param="$3"
        echo $param
        shift;; 
    
    --) shift
        break;;

    *)  arguments_error "illegal option -- ${@:$#}" 
        break;;

    esac
    shift
done

printf "\n"
