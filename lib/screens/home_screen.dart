import 'package:flutter/material.dart';

import '../models/service_request.dart';
import 'service_request_screen.dart';
import 'service_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Main list of service requests
  final List<ServiceRequest> requests = [];

  // Search text
  String searchQuery = '';

  // Selected filter
  String selectedFilter = 'All';

  // Loading state
  bool isLoading = false;

  // CREATE and EDIT
  Future<void> openServiceRequest({
    String service = 'General Service',
    ServiceRequest? existingRequest,
  }) async {
    final result = await Navigator.push<ServiceRequest>(
      context,
      MaterialPageRoute(
        builder: (_) => ServiceRequestScreen(
          selectedService: service,
          existingRequest: existingRequest,
        ),
      ),
    );

    if (!mounted || result == null) {
      return;
    }

    setState(() {
      // CREATE
      if (existingRequest == null) {
        requests.add(result);
      }

      // UPDATE
      else {
        final index = requests.indexWhere(
              (item) => item.id == result.id,
        );

        if (index != -1) {
          requests[index] = result;
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          existingRequest == null
              ? 'Service request added'
              : 'Service request updated',
        ),
      ),
    );
  }

  // DELETE
  Future<void> deleteRequest(
      ServiceRequest request,
      ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Request?'),
          content: Text(
            'Delete the ${request.service} request?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true || !mounted) {
      return;
    }

    setState(() {
      requests.removeWhere(
            (item) => item.id == request.id,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Request deleted'),
      ),
    );
  }

  // COMPLETED / PENDING
  void toggleCompleted(
      ServiceRequest request,
      ) {
    setState(() {
      final index = requests.indexWhere(
            (item) => item.id == request.id,
      );

      if (index != -1) {
        requests[index] = request.copyWith(
          completed: !request.completed,
        );
      }
    });
  }

  // SEARCH + FILTER
  List<ServiceRequest> get filteredRequests {
    return requests.where((request) {
      final query = searchQuery.toLowerCase();

      final matchesSearch =
          request.service
              .toLowerCase()
              .contains(query) ||
              request.name
                  .toLowerCase()
                  .contains(query) ||
              request.email
                  .toLowerCase()
                  .contains(query);

      final matchesFilter =
          selectedFilter == 'All' ||
              (selectedFilter == 'Pending' &&
                  !request.completed) ||
              (selectedFilter == 'Completed' &&
                  request.completed);

      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final visibleRequests = filteredRequests;

    return Scaffold(
      appBar: AppBar(
        title: const Text('LocalServe'),
        centerTitle: true,
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding =
          constraints.maxWidth > 600
              ? 40.0
              : 16.0;

          return ListView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 16,
            ),
            children: [

              // Heading
              const Text(
                'Find Local Home Services',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Choose a service and request a trusted local professional.',
              ),

              const SizedBox(height: 20),

              // SEARCH
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search requests...',
                  prefixIcon: const Icon(
                    Icons.search,
                  ),
                  suffixIcon:
                  searchQuery.isNotEmpty
                      ? IconButton(
                    onPressed: () {
                      setState(() {
                        searchQuery = '';
                      });
                    },
                    icon: const Icon(
                      Icons.clear,
                    ),
                  )
                      : null,
                  border: const OutlineInputBorder(),
                ),

                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),

              const SizedBox(height: 12),

              // FILTER
              DropdownButtonFormField<String>(
                initialValue: selectedFilter,

                decoration:
                const InputDecoration(
                  labelText: 'Filter Requests',
                  border: OutlineInputBorder(),
                ),

                items: const [
                  DropdownMenuItem(
                    value: 'All',
                    child: Text('All'),
                  ),
                  DropdownMenuItem(
                    value: 'Pending',
                    child: Text('Pending'),
                  ),
                  DropdownMenuItem(
                    value: 'Completed',
                    child: Text('Completed'),
                  ),
                ],

                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedFilter = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 20),

              // ADD REQUEST
              SizedBox(
                width: double.infinity,

                child: FilledButton.icon(
                  onPressed: () {
                    openServiceRequest();
                  },

                  icon: const Icon(
                    Icons.add,
                  ),

                  label: const Text(
                    'Request a Service',
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // REQUEST TITLE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Service Requests',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer,
                    ),
                    child: Text(
                      'Completed: ${requests.where((request) => request.completed).length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // LOADING STATE
              if (isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child:
                    CircularProgressIndicator(),
                  ),
                )

              // EMPTY STATE
              else if (visibleRequests.isEmpty)
                Card(
                  child: Padding(
                    padding:
                    const EdgeInsets.all(24),

                    child: Column(
                      children: [

                        const Icon(
                          Icons.inbox_outlined,
                          size: 50,
                        ),

                        const SizedBox(height: 12),

                        Text(
                          requests.isEmpty
                              ? 'No service requests yet.'
                              : 'No matching requests found.',
                          textAlign:
                          TextAlign.center,
                        ),

                        const SizedBox(height: 16),

                        if (requests.isEmpty)
                          OutlinedButton.icon(
                            onPressed: () {
                              openServiceRequest();
                            },

                            icon: const Icon(
                              Icons.add,
                            ),

                            label: const Text(
                              'Create First Request',
                            ),
                          ),
                      ],
                    ),
                  ),
                )

              // REQUEST LIST
              else
                ListView.builder(
                  shrinkWrap: true,

                  physics:
                  const NeverScrollableScrollPhysics(),

                  itemCount:
                  visibleRequests.length,

                  itemBuilder:
                      (context, index) {
                    final request =
                    visibleRequests[index];

                    return Card(
                      margin:
                      const EdgeInsets.only(
                        bottom: 10,
                      ),

                      child: ListTile(
                        // Icon
                        leading: CircleAvatar(
                          child: Icon(
                            request.completed
                                ? Icons.check
                                : Icons.build,
                          ),
                        ),

                        // Service name
                        title: Text(
                          request.service,

                          style: TextStyle(
                            fontWeight:
                            FontWeight.bold,

                            decoration:
                            request.completed
                                ? TextDecoration
                                .lineThrough
                                : null,
                          ),
                        ),

                        // Details
                        subtitle: Text(
                          '${request.name} • '
                              '${request.priority} priority\n'
                              '${request.completed ? 'Completed' : 'Pending'}',
                        ),

                        isThreeLine: true,

                        // Menu
                        trailing:
                        PopupMenuButton<String>(
                          onSelected: (value) {

                            // VIEW
                            if (value == 'view') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ServiceDetailsScreen(
                                        request: request,
                                      ),
                                ),
                              );
                            }

                            // EDIT
                            if (value == 'edit') {
                              openServiceRequest(
                                service:
                                request.service,
                                existingRequest:
                                request,
                              );
                            }

                            // DELETE
                            if (value == 'delete') {
                              deleteRequest(
                                request,
                              );
                            }
                          },

                          itemBuilder:
                              (context) => const [
                            PopupMenuItem(
                              value: 'view',
                              child:
                              Text('View'),
                            ),
                            PopupMenuItem(
                              value: 'edit',
                              child:
                              Text('Edit'),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child:
                              Text('Delete'),
                            ),
                          ],
                        ),

                        // Tap = Complete / Pending
                        onTap: () {
                          toggleCompleted(
                            request,
                          );
                        },
                      ),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}