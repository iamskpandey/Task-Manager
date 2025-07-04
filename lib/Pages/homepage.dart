import 'package:flutter/material.dart';
import 'package:todo_app/services/auth_service.dart';
import 'package:todo_app/services/task_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app/services/image_picker_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String? profileImage;

  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _editTaskController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final FocusNode _searchFocusNode = FocusNode();

  bool isTyping = false;

  @override
  void initState() {
    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus) {
        setState(() {
          isTyping = true;
        });
      } else {
        setState(() {
          isTyping = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _taskController.dispose();
    _editTaskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          backgroundColor: Colors.amber[50],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    DrawerHeader(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                              AuthService().currentUser!.photoURL.toString()),
                          child: InkWell(
                            onTap: () {
                              uploadProfileImage(context);
                            },
                            child: (AuthService().currentUser!.photoURL == null)
                                ? const Icon(
                                    Icons.add_photo_alternate_rounded,
                                    size: 30,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.email,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${AuthService().currentUser!.email}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black87),
                            ),
                          ],
                        )
                      ],
                    )),
                    ListTile(
                      onTap: () => Navigator.pop(context),
                      title: const Text('Home'),
                      leading: const Icon(Icons.home),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/about');
                      },
                      title: const Text('About Us'),
                      leading: const Icon(Icons.info),
                    ),
                  ],
                ),
              ),
              ListTile(
                onTap: () => AuthService().signOut(context: context),
                title: const Text('Logout'),
                leading: const Icon(Icons.logout),
              )
            ],
          )),
      backgroundColor: Colors.amber[50],
      appBar: AppBar(
        title: const Text('Todo app'),
        centerTitle: true,
        backgroundColor: Colors.amber[200],
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
                backgroundImage: NetworkImage(
                    AuthService().currentUser!.photoURL.toString()),
                child: (AuthService().currentUser!.photoURL == null)
                    ? const Icon(Icons.person)
                    : null),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => setState(() {
                _searchController.text = value;
              }),
              focusNode: _searchFocusNode,
              controller: _searchController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search...'),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'All Tasks',
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w400, letterSpacing: 2),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder(
                stream: (isTyping == true)
                    ? TaskService().searchTasks(_searchController.text)
                    : TaskService().getTasks(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        final task = snapshot.data.docs[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: InkWell(
                            onTap: () =>
                                editTaskTitle(task.id, task['taskName']),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.amber[100],
                                  borderRadius: BorderRadius.circular(12)),
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          (task['isCompleted'] == true)
                                              ? InkWell(
                                                  onTap: () => TaskService()
                                                      .updateTaskStatus(task.id,
                                                          task['isCompleted']),
                                                  child: const Icon(
                                                      Icons.check_box,
                                                      color: Colors.black54),
                                                )
                                              : InkWell(
                                                  onTap: () => TaskService()
                                                      .updateTaskStatus(task.id,
                                                          task['isCompleted']),
                                                  child: const Icon(Icons
                                                      .check_box_outline_blank),
                                                ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Flexible(
                                            child: Text(task['taskName'],
                                                style: TextStyle(
                                                  decoration:
                                                      (task['isCompleted'] ==
                                                              true)
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : TextDecoration.none,
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () =>
                                            TaskService().deleteTask(task.id),
                                        child: Icon(
                                          Icons.delete,
                                          color: (task['isCompleted'] == true)
                                              ? Colors.black54
                                              : Colors.black,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[200],
        onPressed: () => addTask(),
        child: const Icon(Icons.add),
      ),
    );
  }

  addTask() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.amber[50],
            title: const Text('Add Task'),
            content: TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.add),
                  hintText: 'Enter task name',
                  border: OutlineInputBorder()),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  )),
              TextButton(
                  style:
                      TextButton.styleFrom(backgroundColor: Colors.amber[200]),
                  onPressed: () {
                    final taskName = _taskController.text;

                    _taskController.clear();

                    if (taskName.isEmpty) {
                      return;
                    } else {
                      TaskService().addTask(taskName);
                    }
                  },
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          );
        });
  }

  editTaskTitle(id, taskName) {
    _editTaskController.text = taskName;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.amber[50],
            title: const Text('Edit Task'),
            content: TextField(
              controller: _editTaskController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.edit),
                  hintText: 'Edit name for $taskName',
                  border: const OutlineInputBorder()),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  )),
              TextButton(
                  style:
                      TextButton.styleFrom(backgroundColor: Colors.amber[200]),
                  onPressed: () {
                    final newTaskName = _editTaskController.text;

                    if (newTaskName.isEmpty) {
                      return;
                    } else {
                      TaskService().editTask(id, newTaskName);
                    }

                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.black),
                  ))
            ],
          );
        });
  }

  void uploadProfileImage(context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose an option'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  profileImage = await ImagePickerService()
                      .selectOrCaputeImage(ImageSource.gallery);
                  setState(() {});
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  profileImage = await ImagePickerService()
                      .selectOrCaputeImage(ImageSource.camera);
                  setState(() {});
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
