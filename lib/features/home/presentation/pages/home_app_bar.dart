// import 'package:flutter/material.dart';
//
// class HomeAppBar extends StatelessWidget {
//   const HomeAppBar({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: Row(
//         children: [
//           const CircleAvatar(
//             radius: 22,
//             backgroundImage: NetworkImage(
//               'https://i.pravatar.cc/150?img=3',
//             ),
//           ),
//           const SizedBox(width: 12),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: const [
//               Text(
//                 'Welcome back',
//                 style: TextStyle(
//                   fontSize: 13,
//                   color: Colors.grey,
//                 ),
//               ),
//               SizedBox(height: 2),
//               Text(
//                 'Alex Thompson',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//           const Spacer(),
//           Container(
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.grey.shade100,
//             ),
//             child: IconButton(
//               icon: const Icon(Icons.notifications_none),
//               onPressed: () {},
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final user = state.user;

        return Container(
          color: Colors.white,
          child: Row(
            children: [

              /// Profile Image
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?img=3',
                ),
              ),

              const SizedBox(width: 12),

              /// Name + Welcome
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    user?.name ?? 'User',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              /// Notification
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade100,
                ),
                child: IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}