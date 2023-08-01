import sys
import os

ORIGINAL = "original"
ASSERTION = "assertion-fix"
SPEC = "spec-fix"

TYPES = [ORIGINAL, ASSERTION, SPEC]

ONLY_VULNERABLE = False

def find_directories():
    current_directory = os.getcwd()  # get the current directory
    all_items = os.listdir(current_directory)  # list all items in the directory
    directories = [
        item for item in all_items if os.path.isdir(item) and not item.startswith(".")
    ]  # filter out files
    return directories

def parse_csv(file_name):
    gas = {} # tx_hash -> (gas_usage, price_per_gas)
    with open(file_name) as f:
        for i, line in enumerate(f):
            if i == 0:
                continue # title
            data = line.strip()
            if len(data) == 0:
                continue
            data = data.split(",")
            gas[data[0].strip()] = (int(data[1]), float(data[2]))
    return gas

def aggregate(hack_dir):
    data_dir = os.path.join(hack_dir, "data")
    data = {}
    for data_type in TYPES:
        file_name = os.path.join(data_dir, f"{data_type}.csv")
        data[data_type] = parse_csv(file_name)

    if ONLY_VULNERABLE:
        valid_txs = set(
            filter(
                lambda tx_hash: data[ORIGINAL][tx_hash] != data[SPEC][tx_hash],
                data[ORIGINAL]
            )
        )
        for data_type in TYPES:
            data[data_type] = {
                k: v for k, v in data[data_type].items() if k in valid_txs
            }

    return data

def get_statistics(data):
    gas_total = sum([gas for tx_hash, (gas, _) in data.items()])
    gas_fee_total = sum([gas * price for tx_hash, (gas, price) in data.items()])
    n = len(data)

    return (n, gas_total / n, gas_fee_total / n)

if __name__ == "__main__":
    if len(sys.argv) > 2:
        print(f"Usage: {sys.argv[0]} [hack-dir]")
        exit(1)

    data = {}
    if len(sys.argv) == 2:
        hack_dir = sys.argv[1]
        data[hack_dir] = aggregate(hack_dir)
    else:
        for hack_dir in find_directories():
            data[hack_dir] = aggregate(hack_dir)

    for hack in data:
        statistics = {}
        for data_type in TYPES:
            statistics[data_type] = get_statistics(data[hack][data_type])

        n, o_gas, o_fee = statistics[ORIGINAL]
        _, a_gas, a_fee = statistics[ASSERTION]
        _, s_gas, s_fee = statistics[SPEC]

        hack_data = hack.split('-')
        hack_type = " ".join(hack_data[:-2]).title()
        victim = hack_data[-2][0].upper() + hack_data[-2][1:]
        fund_loss = hack_data[-1]

        print(f"{victim}\t{fund_loss}\t{hack_type}\t{n}\t{(a_gas-o_gas)/o_gas*10000:.02f}\t{(s_gas-o_gas)/o_gas*10000:.02f}\t{a_fee-o_fee:.4f}\t{s_fee-o_fee:.4f}")






