""" This program will execute the code in /control using the Automation API. """

from pulumi import automation as auto
import argparse
import os
import sys
import json

# Set up the argument parser to capture the --parallelism flag.
parser = argparse.ArgumentParser(
    prog = 'Pulumi AutoAPI Experiment',
    description = 'This experiment tests the automation API\'s ability to scale with concurrency.',
)

parser.add_argument('-p', '--parallelism', type=int)
parser.add_argument('--destroy', type=bool, action=argparse.BooleanOptionalAction)
parser.set_defaults(destroy=False)
args = parser.parse_args()
parallelism = args.parallelism
destroy = args.destroy
assert parallelism in [50, 150, 250, 350]

work_dir = os.path.join(os.path.dirname(__file__), "alternative-control")

# Create our stack using a local program in the ../control directory
stack = auto.create_or_select_stack(stack_name="dev", work_dir=work_dir)
print("successfully initialized stack")

if destroy:
    print("destroying stack...")
    stack.destroy(on_output=print)
    print("stack destroy complete")
    sys.exit()

preview = False
if preview:
    print("previewing stack...")
    stack.preview(on_output=print)
    print("stack preview complete")
    sys.exit()

# print("refreshing stack")
# stack.refresh(on_output=print)
# print("refresh complete")

print("setting up config")
stack.set_config("aws:region", auto.ConfigValue(value="us-east-2"))
print("config set")

print("updating stack...")
up_res = stack.up(on_output=print, parallel=parallelism)
# print(f"update summary: \n{json.dumps(up_res.summary.resource_changes, indent=4)}")
