#!/bin/bash
avg_time() {
    for file in /usr/bin/*; do
        { time -p ./ptrace $file &>/dev/null; } 2>&1              		
    done | awk '
        /real/ { real = real + $2; nr++ }
        /user/ { user = user + $2; nu++ }
        /sys/  { sys  = sys  + $2; ns++}
        END    {
                 if (nr>0) printf("real %f\n", real/nr);
                 if (nu>0) printf("user %f\n", user/nu);
                 if (ns>0) printf("sys %f\n",  sys/ns)
               }'
}
measure() {
	for file in /usr/bin/*; do 
		fsize=$(stat -c%s $file)
		TIME=$( { time -p ./ptrace $file  > /dev/null; } 2>&1 )
		time=$(echo $TIME | grep -o '[^[:space:]]*$')
		echo "$fsize, $time"
	done
}
measure
