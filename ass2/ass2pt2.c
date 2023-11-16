
#include <stdio.h>

int totalFunctionCalls = -1;  //It gets incremented to 0 upon entering main, I only need to count calls to ack3way
int currentFunctionDepth = 0;
int maxFunctionDepth = 0;
int numOverflows = 0;
int windowsUsed = 2;
#define numWindows 8
int numUnderflows = 0;

static inline void increaseDepth(){
    currentFunctionDepth++;
    totalFunctionCalls++;
    if (currentFunctionDepth > maxFunctionDepth){
        maxFunctionDepth = currentFunctionDepth;
    }
    
    if (windowsUsed == numWindows){
        numOverflows++;
    }
    else{
        windowsUsed++;
    }
}
static inline void decreaseDepth(){
    currentFunctionDepth--;
        if (windowsUsed == 2){
            numUnderflows++;
        }
        else{
            windowsUsed--;
        }
}

int ack3way(int m, int n, int p){
    increaseDepth();
    if (p==0){
        decreaseDepth();
        return m+n;
    }
    if (n==0 && p==1){
        decreaseDepth();
        return 0;
    }
    if (n==0 && p==2){
        decreaseDepth();
        return 1;
    }
    if (n==0){
        decreaseDepth();
        return m;
    }
    else{
        int result = ack3way(m, ack3way(m,n-1,p),p-1);
        decreaseDepth();
        return result;
    }
}
int main(){
    increaseDepth();
    int inputs[] = {2,3,3};
    printf("The inputs are %d, %d, %d!\n", inputs[0], inputs[1], inputs[2]);
    printf("Result: %d\n", ack3way(inputs[0],inputs[1],inputs[2]));
    //printf("Max function depth is %d\n", maxFunctionDepth);
    printf("Total number of function calls is %d\n", totalFunctionCalls);
    printf("Total number of overflows is %d\n", numOverflows);
    printf("Total number of underflows is %d\n", numUnderflows);
    printf("Number of underflows is 1 less than the number of overflows because I haven't returned from the main function yet!");
    decreaseDepth();
    return 0;
}
