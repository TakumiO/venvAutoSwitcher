cd() {
      alias ,,ls="/bin/ls" #lsがエイリアスされているのを避ける
      builtin cd "$@"      #素のcdを置き換える

      function activate_venv() {
            venv_number=$(,,ls -U1 .venv | wc -l) #.venvディレクトリにある$venvの数を取得
            if [ $venv_number -lt 1 ]; then       #.venvディレクトリに$venvがない場合
                  echo "No venv found"
            elif [ $venv_number -gt 1 ]; then #.venvディレクトリに複数の$venvがある場合
                  echo "There are over 2 venv dirs"
                  echo "Please select one"
                  select venv_dir in $(,,ls -U1 .venv/); do #.venvディレクトリにある$venvを一覧表示して選択させる
                        if [ -n "$venv_dir" ]; then
                              echo "You selected $venv_dir"
                              break
                        else
                              echo "Invalid selection"
                              continue
                        fi
                  done
                  source .venv/$venv_dir/bin/activate #選択された$venvのbin/activateを実行する
            else                                      #.venvディレクトリに1つのvenvがある場合
                  echo "Activating $(,,ls -U1 .venv/)"
                  source .venv/$(,,ls .venv/)/bin/activate
            fi
      }

      if [ -z "$VIRTUAL_ENV" ]; then 
            if [ -d .venv ]; then
                  activate_venv
            fi

      elif [[ $(pwd) != $(dirname $(dirname "$VIRTUAL_ENV"))/* ]]; then
            deactivate

            if [ -d .venv ]; then 
                  activate_venv
            fi
      fi

}
