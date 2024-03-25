import json

# Accept multi-line input from the user
print("Please enter your text. Press Ctrl+D (Unix/Linux/macOS) or Ctrl+Z followed by Enter (Windows) to end input.")
lines = []
while True:
    try:
        line = input()
    except EOFError:
        break
    lines.append(line)
s = '\n'.join(lines)

# Convert the string to a JSON-compatible form
json_compatible_string = json.dumps(s)

# Output the JSON-compatible string
print(json_compatible_string)

