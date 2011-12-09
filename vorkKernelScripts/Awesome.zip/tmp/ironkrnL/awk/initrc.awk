# Remove scheduler tweaks to use kernel defaults
/sched_latency_ns/ { next; }
/sched_wakeup_granularity_ns/ { next; }
/scaling_min_freq/ { next; }
/scaling_max_freq/ { next; }
/scaling_governor/ { next; }
/sampling_rate/ { next; }

# keep rest of file as is:
{ print; }
