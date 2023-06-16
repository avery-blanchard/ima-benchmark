#include <sys/ptrace.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <sys/user.h>
#include <sys/reg.h>

int main(int argc, char *argv[])
{   
    int waits, status;
    pid_t child;
    struct user_regs_struct regs;
   
    if (argc < 1) 
    	return -1;

    child = fork();
    if(child == 0) {
        ptrace(PTRACE_TRACEME, 0, NULL, NULL);
        execl(argv[1], "", NULL);
    }
    else {
	wait(&waits);
	ptrace(PTRACE_SINGLESTEP, child, 0, 0);
	wait(&waits);
	while (waits == 1407) {
		ptrace(PTRACE_SINGLESTEP, child, 0, 0);
		wait(&waits);
		return 0;
	}
    }
    return 0;
}
