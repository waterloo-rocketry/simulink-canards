import re

def validate_timestamps(log_file_path):
    timestamp_pattern = re.compile(r"\[(\d+\.\d+)\]")
    timestamps = []

    # Read and extract timestamps
    with open(log_file_path, 'r') as file:
        for line in file:
            match = timestamp_pattern.match(line)
            if match:
                timestamps.append(float(match.group(1)))

    # Check differences
    all_within_limit = True
    for i in range(1, len(timestamps)):
        diff = timestamps[i] - timestamps[i - 1]
        if diff > 5:
            print(f"Time difference too large: {timestamps[i - 1]} -> {timestamps[i]} (Δ={diff:.1f})")
            all_within_limit = False

    if all_within_limit:
        print("All timestamp differences are within 5 seconds.")

# Example usage
log_file_path = "00000018.TXT"  # Replace with your actual file path
validate_timestamps(log_file_path)

