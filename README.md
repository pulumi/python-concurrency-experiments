## Setup

Setup AWS Access:

```bash
export AWS_ACCESS_KEY_ID="XXXXXXX"
export AWS_SECRET_ACCESS_KEY="XXXXXX"
export AWS_SESSION_TOKEN="XXXXXX"
```

## Dependencies

You will need to install [Hyperfine](https://github.com/sharkdp/hyperfine) and Pulumi.

## Running the Experiments

Experiments are separated into subdirectories of `/scripts`. Each directory has its own `run.sh` file, which must be executed from the top level of this repo.

Download the Pulumi repo to `$HOME/pulumi/pulumi`.

* __automation:__ This experiment compares Python programs running Automation API to Python CLI programs.
* __ts-vs-py:__ This experiment compares TypeScript to Python performance using newer versions of Pulumi, where they should perform comparably.

To run all of the experiments, from this directory, execute:

```bash
$ ./scripts/run.bash
```

