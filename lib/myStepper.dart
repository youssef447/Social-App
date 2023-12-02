import 'package:flutter/material.dart';
import 'package:social_app/constants.dart';
class myCustomStepper extends StatelessWidget {

  
   final List<Steps> steps;
 final  bool isLast;
   final int currentIndex;
   final Function() onForwardStep;
   final Function() onBackStep;

  const myCustomStepper({super.key,
  required this.steps,
  required this.isLast,
  required this. currentIndex,
  required this. onForwardStep,
  required this. onBackStep,
});

  @override
  Widget build(BuildContext context) {
   return Column(
    children: [
      Row(
        children: List.generate(steps.length, (index) {
          return index != steps.length - 1
              ? Expanded(
                  child: stepCircle(
                  steps[index],
                  index,
                  steps.length,
                ))
              : stepCircle(steps[index], index, steps.length);
        }),
      ),
      Expanded(child: steps[currentIndex].content),
      /*  currentIndex == 0
          ? defaultElevatedButton(
              height: 50,
              text: 'Next',
              onPressed: () {
                onForwardStep();
              },
              width: double.infinity,
            )
          : currentIndex == steps.length - 1
              ? Row(
                  children: [
                    Expanded(
                      child: defaultElevatedButton(
                          height: 50, text: 'Back', onPressed: onBackStep),
                    ),
                    const Spacer(),
                    Expanded(
                      child: defaultElevatedButton(
                        height: 50,
                        text: 'Verify',
                        onPressed: onForwardStep,
                        width: double.infinity,
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: defaultElevatedButton(
                          height: 50, text: 'Back', onPressed: onBackStep),
                    ),
                    const Spacer(),
                    Expanded(
                      child: defaultElevatedButton(
                          height: 50, text: 'Next', onPressed: onForwardStep),
                    )
                    
 */
    ],
  );
  }
}

class Steps {
  String title;
  Widget content;
  bool isActive;
  IconData icon;
  bool completed;
  Function()?onTapped;

  Steps(
      {required this.title,
      required this.content,
      required this.isActive,
      required this.completed,
       this.onTapped,
      required this.icon});
}

Widget stepCircle(
  Steps steps,
  int index,
  int itemCount,
) {
  return index == itemCount - 1
      ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          FittedBox(
            child: Text(
              steps.title,
              style: TextStyle(
                  color: steps.isActive ? defaultColor : Colors.black,
                  fontWeight:
                      steps.completed ? FontWeight.bold : FontWeight.normal),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: GestureDetector(
              onTap: steps.onTapped,
              child: CircleAvatar(
                backgroundColor: steps.isActive ? defaultColor : Colors.grey,
                radius: 26,
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    backgroundColor:
                        steps.isActive ? defaultColor : Colors.white,
                    radius: 16,
                    child: !steps.completed
                        ? Icon(
                            steps.icon,
                            color:
                                !steps.isActive ? Colors.black : Colors.white,
                          )
                        : const Icon(
                            Icons.done,
                            color: Colors.white,
                          ),
                  ),
                ),
              ),
            ),
          )
        ])
      : Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              FittedBox(
                child: Text(
                  steps.title,
                  style: TextStyle(
                      color: steps.isActive ? defaultColor : Colors.black,
                      fontWeight: steps.completed
                          ? FontWeight.bold
                          : FontWeight.normal),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: GestureDetector(
                      onTap: steps.onTapped,
                      child: CircleAvatar(
                        backgroundColor:
                            steps.isActive ? defaultColor : Colors.grey,
                        radius: 26,
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            backgroundColor:
                                steps.isActive ? defaultColor : Colors.white,
                            radius: 16,
                            child: FittedBox(
                              child: !steps.completed
                                  ? Icon(
                                      steps.icon,
                                      color: !steps.isActive
                                          ? Colors.black
                                          : Colors.white,
                                    )
                                  : const Icon(
                                      Icons.done,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 2,
                      color: steps.completed ? defaultColor : Colors.grey,
                    ),
                  )
                ],
              ),
            ]);
}


