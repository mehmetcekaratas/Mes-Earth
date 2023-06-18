library dashboard;

import 'dart:developer';
import 'dart:js';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:project_management/app/constans/app_constants.dart';
import 'package:project_management/app/features/dashboard/views/components/progress_bar.dart';
import 'package:project_management/app/shared_components/chatting_card.dart';
import 'package:project_management/app/shared_components/get_premium_card.dart';
import 'package:project_management/app/shared_components/list_profil_image.dart';
import 'package:project_management/app/shared_components/progress_card.dart';
import 'package:project_management/app/shared_components/progress_report_card.dart';
import 'package:project_management/app/shared_components/responsive_builder.dart';
import 'package:project_management/app/shared_components/upgrade_premium_card.dart';
import 'package:project_management/app/shared_components/project_card.dart';
import 'package:project_management/app/shared_components/search_field.dart';
import 'package:project_management/app/shared_components/selection_button.dart';
import 'package:project_management/app/shared_components/task_card.dart';
import 'package:project_management/app/shared_components/today_text.dart';
import 'package:project_management/app/utils/helpers/app_helpers.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../components/chat_popup.dart';

// binding
part '../../bindings/dashboard_binding.dart';

// controller
part '../../controllers/dashboard_controller.dart';

// models
part '../../models/profile.dart';

// component
part '../components/active_project_card.dart';
part '../components/header.dart';
part '../components/overview_header.dart';
part '../components/profile_tile.dart';
part '../components/recent_messages.dart';
part '../components/sidebar.dart';
part '../components/team_member.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      drawer: (ResponsiveBuilder.isDesktop(context))
          ? null
          : Drawer(
              child: Padding(
                padding: const EdgeInsets.only(top: kSpacing),
                child: _Sidebar(data: controller.getSelectedProject()),
              ),
            ),
      body: SingleChildScrollView(
          child: ResponsiveBuilder(
        mobileBuilder: (context, constraints) {
          return Column(children: [
            const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
            _buildHeader(onPressedMenu: () => controller.openDrawer()),
            const SizedBox(height: kSpacing / 2),
            const Divider(),
            _buildProfile(data: controller.getProfil()),
            const SizedBox(height: kSpacing),
            _buildProgress(axis: Axis.vertical,context: context),
            const SizedBox(height: kSpacing),
            _buildTeamMember(data: controller.getMember()),
            const SizedBox(height: kSpacing),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kSpacing),
              child: GetPremiumCard(onPressed: () {}),
            ),
            const SizedBox(height: kSpacing * 2),
            _buildTaskOverview(
              data: controller.getAllTask(),
              headerAxis: Axis.vertical,
              crossAxisCount: 6,
              crossAxisCellCount: 6,
            ),
            const SizedBox(height: kSpacing * 2),
            _buildActiveProject(
              data: controller.getActiveProject(),
              crossAxisCount: 6,
              crossAxisCellCount: 6,
            ),
            const SizedBox(height: kSpacing),
            ProgressBarWithIndicator(progress: 0.5, indicatorColor: Colors.amberAccent, count: 9),
            const SizedBox(height: kSpacing),
            _buildRecentMessages(data: controller.getChatting(),context: context),
          ]);
        },
        tabletBuilder: (context, constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: (constraints.maxWidth < 950) ? 6 : 9,
                child: Column(
                  children: [
                    const SizedBox(height: kSpacing * (kIsWeb ? 1 : 2)),
                    _buildHeader(onPressedMenu: () => controller.openDrawer()),
                    const SizedBox(height: kSpacing * 2),
                    _buildProgress(
                      context: context,
                      axis: (constraints.maxWidth < 950)
                          ? Axis.vertical
                          : Axis.horizontal,
                    ),
                    const SizedBox(height: kSpacing * 2),
                    _buildTaskOverview(
                      data: controller.getAllTask(),
                      headerAxis: (constraints.maxWidth < 850)
                          ? Axis.vertical
                          : Axis.horizontal,
                      crossAxisCount: 6,
                      crossAxisCellCount: (constraints.maxWidth < 950)
                          ? 6
                          : (constraints.maxWidth < 1100)
                              ? 3
                              : 2,
                    ),
                    const SizedBox(height: kSpacing * 2),
                    _buildActiveProject(
                      data: controller.getActiveProject(),
                      crossAxisCount: 6,
                      crossAxisCellCount: (constraints.maxWidth < 950)
                          ? 6
                          : (constraints.maxWidth < 1100)
                              ? 3
                              : 2,
                    ),
                    const SizedBox(height: kSpacing),
                    Container(child:ProgressBarWithIndicator(progress: 0.5, indicatorColor: Colors.amberAccent,count: 5,)),
                  ],
                ),
              ),
              Flexible(
                flex: 4,
                child: Column(
                  children: [
                    const SizedBox(height: kSpacing * (kIsWeb ? 0.5 : 1.5)),
                    _buildProfile(data: controller.getProfil()),
                    const Divider(thickness: 1),
                    const SizedBox(height: kSpacing),
                    _buildTeamMember(data: controller.getMember()),
                    const SizedBox(height: kSpacing),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
                      child: GetPremiumCard(onPressed: () {}),
                    ),
                    const SizedBox(height: kSpacing),
                    ProgressBarWithIndicator(progress: 0.5, indicatorColor: Colors.amberAccent,count: 5),
                    const SizedBox(height: kSpacing),
                    const Divider(thickness: 1),
                    const SizedBox(height: kSpacing),
                    _buildRecentMessages(data: controller.getChatting(),context: context),


                  ],
                ),
              )
            ],
          );
        },
        desktopBuilder: (context, constraints) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: (constraints.maxWidth < 1360) ? 4 : 3,
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(kBorderRadius),
                      bottomRight: Radius.circular(kBorderRadius),
                    ),
                    child: _Sidebar(data: controller.getSelectedProject())),
              ),
              Flexible(
                flex: 9,
                child: Column(
                  children: [
                    const SizedBox(height: kSpacing),
                    _buildHeader(),
                    const SizedBox(height: kSpacing * 2),
                    _buildProgress(context: context),
                    const SizedBox(height: kSpacing),
                    ProgressBarWithIndicator(progress: 0.5, indicatorColor: Colors.amberAccent,count: 9),
                    const SizedBox(height: kSpacing * 2),
                    _buildTaskOverview(
                      data: controller.getAllTask(),
                      crossAxisCount: 6,
                      crossAxisCellCount: (constraints.maxWidth < 1360) ? 3 : 2,
                    ),
                    const SizedBox(height: kSpacing * 2),
                    _buildActiveProject(
                      data: controller.getActiveProject(),
                      crossAxisCount: 6,
                      crossAxisCellCount: (constraints.maxWidth < 1360) ? 3 : 2,
                    ),
                    const SizedBox(height: kSpacing),
                  ],
                ),
              ),
              Flexible(
                flex: 4,
                child: Column(
                  children: [
                    const SizedBox(height: kSpacing / 2),
                    _buildProfile(data: controller.getProfil()),
                    const Divider(thickness: 1),
                    const SizedBox(height: kSpacing),
                    _buildTeamMember(data: controller.getMember()),
                    const SizedBox(height: kSpacing),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
                      child: GetPremiumCard(onPressed: () {}),
                    ),
                    const SizedBox(height: kSpacing),
                    /*Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
                      child: Container(
                        child: const Image(image: AssetImage('assets/images/raster/mes.png')),
                      ),
                    ),*/

                    const SizedBox(height: kSpacing),
                    const Divider(thickness: 1),
                    const SizedBox(height: kSpacing),
                    _buildRecentMessages(data: controller.getChatting(),context: context),
                  ],
                ),
              )
            ],
          );
        },
      )),
    );
  }

  Widget _buildHeader({Function()? onPressedMenu}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Row(
        children: [
          if (onPressedMenu != null)
            Padding(
              padding: const EdgeInsets.only(right: kSpacing),
              child: IconButton(
                onPressed: onPressedMenu,
                icon: const Icon(EvaIcons.menu),
                tooltip: "Menu",
              ),
            ),
          const Expanded(child: _Header()),
        ],
      ),
    );
  }

  Widget _buildProgress({Axis axis = Axis.horizontal,required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: (axis == Axis.horizontal)
          ? Row(
              children: [
                Flexible(
                  flex: 5,
                  child: ProgressCard(
                    data: const ProgressCardData(
                      totalUndone: 10,
                      totalTaskInProress: 2,
                    ),
                    onPressedCheck: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('2 Cihaz Uyarı Veriyor'),
                          content: const Text('123654 ve 898353 ID numaralarına sahip \ncihazlarınızda Eğim ve Hasar Uyarısı bulunmaktadır. \nLütfen Acil Şekilde Bursa Belediyesi \nMesEarth Takımı ile iletişime geçin \nTel: 444 1 444'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Kapat'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: kSpacing / 2),
                const Flexible(
                  flex: 4,
                  child: ProgressReportCard(
                    data: ProgressReportCardData(
                      title: "MesEARTH Evinde",
                      percent: .82,
                      ay: 9,
                      gun: 285,
                      kalanGun: 65
                    ),
                  ),
                ),
              ],
            )
          : Column(
              children: [
                ProgressCard(
                  data: const ProgressCardData(
                    totalUndone: 10,
                    totalTaskInProress: 2,
                  ),
                  onPressedCheck: () {},
                ),
                const SizedBox(height: kSpacing / 2),
                const ProgressReportCard(
                  data: ProgressReportCardData(
                      title: "MesEARTH ile \nKorunursunuz",
                      percent: .82,
                      ay: 9,
                      gun: 285,
                      kalanGun: 65
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTaskOverview({
    required List<TaskCardData> data,
    int crossAxisCount = 6,
    int crossAxisCellCount = 2,
    Axis headerAxis = Axis.horizontal,
  }) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: crossAxisCount,
      itemCount: data.length + 1,
      addAutomaticKeepAlives: false,
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return (index == 0)
            ? Padding(
                padding: const EdgeInsets.only(bottom: kSpacing),
                child: _OverviewHeader(
                  axis: headerAxis,
                  onSelected: (task) {},
                ),
              )
            : TaskCard(
                data: data[index - 1],
                onPressedMore: () {},
                onPressedTask: () {},
                onPressedContributors: () {},
                onPressedComments: () {},
              );
      },
      staggeredTileBuilder: (int index) =>
          StaggeredTile.fit((index == 0) ? crossAxisCount : crossAxisCellCount),
    );
  }

  Widget _buildActiveProject({
    required List<ProjectCardData> data,
    int crossAxisCount = 6,
    int crossAxisCellCount = 2,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: _ActiveProjectCard(
        onPressedSeeAll: () {},
        child: StaggeredGridView.countBuilder(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          itemCount: data.length,
          addAutomaticKeepAlives: false,
          mainAxisSpacing: kSpacing,
          crossAxisSpacing: kSpacing,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ProjectCard(data: data[index]);
          },
          staggeredTileBuilder: (int index) =>
              StaggeredTile.fit(crossAxisCellCount),
        ),
      ),
    );
  }

  Widget _buildProfile({required _Profile data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: _ProfilTile(
        data: data,
        onPressedNotification: () {},
      ),
    );
  }

  Widget _buildTeamMember({required List<ImageProvider> data}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TeamMember(
            totalMember: data.length,
            onPressedAdd: () {},
          ),
          const SizedBox(height: kSpacing / 2),
          ListProfilImage(maxImages: 6, images: data),
        ],
      ),
    );
  }

  Widget _buildRecentMessages({required List<ChattingCardData> data, required BuildContext context}) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: kSpacing),
        child: _RecentMessages(onPressedMore: () {
          List<String> unreadMessages = [
            'Merhaba, nasılsın?',
            'Bugün buluşabilir miyiz?',
            'Yeni bir mesaj aldın!'
          ];

          showDialog(
            context: context,
            builder: (context) {
              return ChatPopup(messages: unreadMessages);
            },
          );
        }),
      ),
      const SizedBox(height: kSpacing / 2),
      ...data
          .map(
            (e) => ChattingCard(data: e, onPressed: () {}),
          )
          .toList(),
    ]);
  }
}
