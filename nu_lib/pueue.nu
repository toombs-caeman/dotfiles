module completions {

  def "nu-complete pueue color" [] {
    [ "auto" "never" "always" ]
  }

  # Interact with the Pueue daemon
  export extern pueue [
    --verbose(-v)             # Verbose mode (-v, -vv, -vvv)
    --color: string@"nu-complete pueue color" # Colorize the output; auto enables color output when connected to a tty
    --config(-c): string      # If provided, Pueue only uses this config file. This path can also be set via the "PUEUE_CONFIG_PATH" environment variable. The commandline option overwrites the environment variable!
    --profile(-p): string     # The name of the profile that should be loaded from your config file
    --help(-h)                # Print help
    --version(-V)             # Print version
  ]

  # Enqueue a task for execution. There're many different options when scheduling a task. Check the individual option help texts for more information.  Furthermore, please remember that scheduled commands are executed via your system shell. This means that the command needs proper shell escaping. The safest way to preserve shell escaping is to surround your command with quotes, for example: pueue add 'ls $HOME && echo "Some string"'
  export extern "pueue add" [
    ...command: string        # The command to be added
    --working-directory(-w): string # Specify current working directory
    --escape(-e)              # Escape any special shell characters (" ", "&", "!", etc.). Beware: This implicitly disables nearly all shell specific syntax ("&&", "&>")
    --immediate(-i)           # Immediately start the task
    --stashed(-s)             # Create the task in Stashed state. Useful to avoid immediate execution if the queue is empty
    --delay(-d): string       # Prevents the task from being enqueued until 'delay' elapses. See "enqueue" for accepted formats
    --group(-g): string       # Assign the task to a group. Groups kind of act as separate queues. I.e. all groups run in parallel and you can specify the amount of parallel tasks for each group. If no group is specified, the default group will be used
    --after(-a): string       # Start the task once all specified tasks have successfully finished. As soon as one of the dependencies fails, this task will fail as well
    --priority(-o): string    # Start this task with a higher priority. The higher the number, the faster it will be processed
    --label(-l): string       # Add some information for yourself. This string will be shown in the "status" table. There's no additional logic connected to it
    --print-task-id(-p)       # Only return the task id instead of a text. This is useful when working with dependencies
    --help(-h)                # Print help
  ]

  # Remove tasks from the list. Running or paused tasks need to be killed first
  export extern "pueue remove" [
    ...task_ids: string       # The task ids to be removed
    --help(-h)                # Print help
  ]

  # Switches the queue position of two commands. Only works on queued and stashed commands
  export extern "pueue switch" [
    task_id_1: string         # The first task id
    task_id_2: string         # The second task id
    --help(-h)                # Print help
  ]

  # Stashed tasks won't be automatically started. You have to enqueue them or start them by hand
  export extern "pueue stash" [
    ...task_ids: string       # Stash these specific tasks
    --help(-h)                # Print help
  ]

  # Enqueue stashed tasks. They'll be handled normally afterwards
  export extern "pueue enqueue" [
    ...task_ids: string       # Enqueue these specific tasks
    --delay(-d): string       # Delay enqueuing these tasks until 'delay' elapses. See DELAY FORMAT below
    --help(-h)                # Print help
  ]

  # Resume operation of specific tasks or groups of tasks. By default, this resumes the default group and all its tasks. Can also be used force-start specific tasks.
  export extern "pueue start" [
    ...task_ids: string       # Start these specific tasks. Paused tasks will resumed. Queued or Stashed tasks will be force-started
    --group(-g): string       # Resume a specific group and all paused tasks in it. The group will be set to running and its paused tasks will be resumed
    --all(-a)                 # Resume all groups! All groups will be set to running and paused tasks will be resumed
    --children(-c)            # Deprecated: this switch no longer has any effect
    --help(-h)                # Print help
  ]

  # Restart failed or successful task(s). By default, identical tasks will be created and enqueued, but it's possible to restart in-place. You can also edit a few properties, such as the path and the command, before restarting.
  export extern "pueue restart" [
    ...task_ids: string       # Restart these specific tasks
    --all-failed(-a)          # Restart all failed tasks across all groups. Nice to use in combination with `-i/--in-place`
    --failed-in-group(-g): string # Like `--all-failed`, but only restart tasks failed tasks of a specific group. The group will be set to running and its paused tasks will be resumed
    --start-immediately(-k)   # Immediately start the tasks, no matter how many open slots there are. This will ignore any dependencies tasks may have
    --stashed(-s)             # Set the restarted task to a "Stashed" state. Useful to avoid immediate execution
    --in-place(-i)            # Restart the task by reusing the already existing tasks. This will overwrite any previous logs of the restarted tasks
    --not-in-place            # Restart the task by creating a new identical tasks. Only applies, if you have the restart_in_place configuration set to true
    --edit(-e)                # Edit the tasks' commands before restarting
    --edit-path(-p)           # Edit the tasks' paths before restarting
    --edit-label(-l)          # Edit the tasks' labels before restarting
    --edit-priority(-o)       # Edit the tasks' priorities before restarting
    --help(-h)                # Print help
  ]

  # Either pause running tasks or specific groups of tasks. By default, pauses the default group and all its tasks. A paused queue (group) won't start any new tasks.
  export extern "pueue pause" [
    ...task_ids: string       # Pause these specific tasks. Does not affect the default group, groups or any other tasks
    --group(-g): string       # Pause a specific group
    --all(-a)                 # Pause all groups!
    --wait(-w)                # Only pause the specified group and let already running tasks finish by themselves
    --children(-c)            # Deprecated: this switch no longer has any effect
    --help(-h)                # Print help
  ]

  # Kill specific running tasks or whole task groups.. Kills all tasks of the default group when no ids or a specific group are provided.
  export extern "pueue kill" [
    ...task_ids: string       # Kill these specific tasks
    --group(-g): string       # Kill all running tasks in a group. This also pauses the group
    --all(-a)                 # Kill all running tasks across ALL groups. This also pauses all groups
    --children(-c)            # Deprecated: this switch no longer has any effect
    --signal(-s): string      # Send a UNIX signal instead of simply killing the process. DISCLAIMER: This bypasses Pueue's process handling logic! You might enter weird invalid states, use at your own descretion
    --help(-h)                # Print help
  ]

  # Send something to a task. Useful for sending confirmations such as 'y\n'
  export extern "pueue send" [
    task_id: string           # The id of the task
    input: string             # The input that should be sent to the process
    --help(-h)                # Print help
  ]

  # Edit the command, path, label, or priority of a stashed or queued task. By default only the command is edited. Multiple properties can be added in one go.
  export extern "pueue edit" [
    task_id: string           # The task's id
    --command(-c)             # Edit the task's command
    --path(-p)                # Edit the task's path
    --label(-l)               # Edit the task's label
    --priority(-o)            # Edit the task's priority
    --help(-h)                # Print help
  ]

  # Use this to add or remove groups. By default, this will simply display all known groups.
  export extern "pueue group" [
    --json(-j)                # Print the list of groups as json
    --help(-h)                # Print help
  ]

  # Add a group by name
  export extern "pueue group add" [
    name: string
    --parallel(-p): string    # Set the amount of parallel tasks this group can have. Setting this to 0 means an unlimited amount of parallel tasks
    --help(-h)                # Print help
  ]

  # Remove a group by name. This will move all tasks in this group to the default group!
  export extern "pueue group remove" [
    name: string
    --help(-h)                # Print help
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pueue group help" [
  ]

  # Add a group by name
  export extern "pueue group help add" [
  ]

  # Remove a group by name. This will move all tasks in this group to the default group!
  export extern "pueue group help remove" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pueue group help help" [
  ]

  # Display the current status of all tasks
  export extern "pueue status" [
    ...query: string          # Users can specify a custom query to filter for specific values, order by a column or limit the amount of tasks listed. Use `--help` for the full syntax definition
    --json(-j)                # Print the current state as json to stdout. This does not include the output of tasks. Use `log -j` if you want everything
    --group(-g): string       # Only show tasks of a specific group
    --help(-h)                # Print help (see more with '--help')
  ]

  # Accept a list or map of JSON pueue tasks via stdin and display it just like "pueue status". A simple example might look like this: pueue status --json | jq -c '.tasks' | pueue format-status
  export extern "pueue format-status" [
    --group(-g): string       # Only show tasks of a specific group
    --help(-h)                # Print help
  ]

  # Display the log output of finished tasks. Only the last few lines will be shown by default. If you want to follow the output of a task, please use the "follow" subcommand.
  export extern "pueue log" [
    ...task_ids: string       # View the task output of these specific tasks
    --json(-j)                # Print the resulting tasks and output as json. By default only the last lines will be returned unless --full is provided. Take care, as the json cannot be streamed! If your logs are really huge, using --full can use all of your machine's RAM
    --lines(-l): string       # Only print the last X lines of each task's output. This is done by default if you're looking at multiple tasks
    --full(-f)                # Show the whole output
    --help(-h)                # Print help
  ]

  # Follow the output of a currently running task. This command works like "tail -f"
  export extern "pueue follow" [
    task_id?: string          # The id of the task you want to watch. If no or multiple tasks are running, you have to specify the id. If only a single task is running, you can omit the id
    --lines(-l): string       # Only print the last X lines of the output before following
    --help(-h)                # Print help
  ]

  # Wait until tasks are finished. By default, this will wait for all tasks in the default group to finish. Note: This will also wait for all tasks that aren't somehow 'Done'. Includes: [Paused, Stashed, Locked, Queued, ...]
  export extern "pueue wait" [
    ...task_ids: string       # This allows you to wait for specific tasks to finish
    --group(-g): string       # Wait for all tasks in a specific group
    --all(-a)                 # Wait for all tasks across all groups and the default group
    --quiet(-q)               # Don't show any log output while waiting
    --status(-s): string      # Wait for tasks to reach a specific task status
    --help(-h)                # Print help
  ]

  # Remove all finished tasks from the list
  export extern "pueue clean" [
    --successful-only(-s)     # Only clean tasks that finished successfully
    --group(-g): string       # Only clean tasks of a specific group
    --help(-h)                # Print help
  ]

  # Kill all tasks, clean up afterwards and reset EVERYTHING!
  export extern "pueue reset" [
    --children(-c)            # Deprecated: this switch no longer has any effect
    --force(-f)               # Don't ask for any confirmation
    --help(-h)                # Print help
  ]

  # Remotely shut down the daemon. Should only be used if the daemon isn't started by a service manager
  export extern "pueue shutdown" [
    --help(-h)                # Print help
  ]

  # Set the amount of allowed parallel tasks By default, adjusts the amount of the default group. No tasks will be stopped, if this is lowered. This limit is only considered when tasks are scheduled.
  export extern "pueue parallel" [
    parallel_tasks?: string   # The amount of allowed parallel tasks. Setting this to 0 means an unlimited amount of parallel tasks
    --group(-g): string       # Set the amount for a specific group
    --help(-h)                # Print help
  ]

  def "nu-complete pueue completions shell" [] {
    [ "bash" "elvish" "fish" "power-shell" "zsh" "nushell" ]
  }

  # Generates shell completion files. This can be ignored during normal operations
  export extern "pueue completions" [
    shell: string@"nu-complete pueue completions shell" # The target shell
    output_directory?: string # The output directory to which the file should be written
    --help(-h)                # Print help
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pueue help" [
  ]

  # Enqueue a task for execution. There're many different options when scheduling a task. Check the individual option help texts for more information.  Furthermore, please remember that scheduled commands are executed via your system shell. This means that the command needs proper shell escaping. The safest way to preserve shell escaping is to surround your command with quotes, for example: pueue add 'ls $HOME && echo "Some string"'
  export extern "pueue help add" [
  ]

  # Remove tasks from the list. Running or paused tasks need to be killed first
  export extern "pueue help remove" [
  ]

  # Switches the queue position of two commands. Only works on queued and stashed commands
  export extern "pueue help switch" [
  ]

  # Stashed tasks won't be automatically started. You have to enqueue them or start them by hand
  export extern "pueue help stash" [
  ]

  # Enqueue stashed tasks. They'll be handled normally afterwards
  export extern "pueue help enqueue" [
  ]

  # Resume operation of specific tasks or groups of tasks. By default, this resumes the default group and all its tasks. Can also be used force-start specific tasks.
  export extern "pueue help start" [
  ]

  # Restart failed or successful task(s). By default, identical tasks will be created and enqueued, but it's possible to restart in-place. You can also edit a few properties, such as the path and the command, before restarting.
  export extern "pueue help restart" [
  ]

  # Either pause running tasks or specific groups of tasks. By default, pauses the default group and all its tasks. A paused queue (group) won't start any new tasks.
  export extern "pueue help pause" [
  ]

  # Kill specific running tasks or whole task groups.. Kills all tasks of the default group when no ids or a specific group are provided.
  export extern "pueue help kill" [
  ]

  # Send something to a task. Useful for sending confirmations such as 'y\n'
  export extern "pueue help send" [
  ]

  # Edit the command, path, label, or priority of a stashed or queued task. By default only the command is edited. Multiple properties can be added in one go.
  export extern "pueue help edit" [
  ]

  # Use this to add or remove groups. By default, this will simply display all known groups.
  export extern "pueue help group" [
  ]

  # Add a group by name
  export extern "pueue help group add" [
  ]

  # Remove a group by name. This will move all tasks in this group to the default group!
  export extern "pueue help group remove" [
  ]

  # Display the current status of all tasks
  export extern "pueue help status" [
  ]

  # Accept a list or map of JSON pueue tasks via stdin and display it just like "pueue status". A simple example might look like this: pueue status --json | jq -c '.tasks' | pueue format-status
  export extern "pueue help format-status" [
  ]

  # Display the log output of finished tasks. Only the last few lines will be shown by default. If you want to follow the output of a task, please use the "follow" subcommand.
  export extern "pueue help log" [
  ]

  # Follow the output of a currently running task. This command works like "tail -f"
  export extern "pueue help follow" [
  ]

  # Wait until tasks are finished. By default, this will wait for all tasks in the default group to finish. Note: This will also wait for all tasks that aren't somehow 'Done'. Includes: [Paused, Stashed, Locked, Queued, ...]
  export extern "pueue help wait" [
  ]

  # Remove all finished tasks from the list
  export extern "pueue help clean" [
  ]

  # Kill all tasks, clean up afterwards and reset EVERYTHING!
  export extern "pueue help reset" [
  ]

  # Remotely shut down the daemon. Should only be used if the daemon isn't started by a service manager
  export extern "pueue help shutdown" [
  ]

  # Set the amount of allowed parallel tasks By default, adjusts the amount of the default group. No tasks will be stopped, if this is lowered. This limit is only considered when tasks are scheduled.
  export extern "pueue help parallel" [
  ]

  # Generates shell completion files. This can be ignored during normal operations
  export extern "pueue help completions" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "pueue help help" [
  ]

}

export use completions *
