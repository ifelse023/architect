#!/bin/bash

# Function to check if HyperX headset is connected and set it as default
set_hyperx_default() {
  # List sinks and search for HyperX in the name
  HYPERX_SINK=$(pactl list short sinks | grep -i "HyperX" | awk '{print $2}')

  if [ -n "$HYPERX_SINK" ]; then
    echo "HyperX headset found: $HYPERX_SINK"

    # Set the HyperX sink as the default
    pactl set-default-sink "$HYPERX_SINK"

    # Verify the change
    CURRENT_DEFAULT=$(pactl info | grep "Default Sink" | awk '{print $3}')
    if [ "$CURRENT_DEFAULT" = "$HYPERX_SINK" ]; then
      echo "Successfully set $HYPERX_SINK as default audio output."

      # Optionally move existing streams to the HyperX sink
      SINK_INPUTS=$(pactl list short sink-inputs | awk '{print $1}')
      if [ -n "$SINK_INPUTS" ]; then
        echo "Moving existing audio streams to HyperX..."
        for INPUT in $SINK_INPUTS; do
          pactl move-sink-input "$INPUT" "$HYPERX_SINK"
        done
        echo "Streams moved successfully."
      else
        echo "No active audio streams to move."
      fi
    else
      echo "Failed to set $HYPERX_SINK as default. Check PipeWire status."
    fi
  else
    echo "No HyperX headset detected."
  fi
}

# Run the function
set_hyperx_default
