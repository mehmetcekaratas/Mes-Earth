part of dashboard;

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.data,
    Key? key,
  }) : super(key: key);

  final ProjectCardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(kSpacing),
              child: ProjectCard(
                data: data,
              ),
            ),
            const Divider(thickness: 1),
            SelectionButton(
              data: [
                SelectionButtonData(
                  activeIcon: EvaIcons.grid,
                  icon: EvaIcons.gridOutline,
                  label: "Anasayfa",
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.archive,
                  icon: EvaIcons.archiveOutline,
                  label: "Raporlar",
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.calendar,
                  icon: EvaIcons.calendarOutline,
                  label: "Takvim",
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.email,
                  icon: EvaIcons.emailOutline,
                  label: "Email",
                  totalNotif: 20,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.person,
                  icon: EvaIcons.personOutline,
                  label: "Profil",
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.settings,
                  icon: EvaIcons.settingsOutline,
                  label: "Ayarlar",
                ),
              ],
              onSelected: (index, value) {
                log("index : $index | label : ${value.label}");
                // Butona tıklandığında yapılacak işlemleri buraya ekleyebilirsiniz
                // Örneğin, farklı sayfaları açmak için gerekli yönlendirme işlemlerini yapabilirsiniz
                switch (index) {
                  case 0:
                  // Anasayfa sayfasını açmak için gerekli kodları buraya yazın
                  // Örneğin, Get.toNamed('/anasayfa') kullanabilirsiniz
                    break;
                  case 1:
                  // Raporlar sayfasını açmak için gerekli kodları buraya yazın
                  // Örneğin, Get.toNamed('/raporlar') kullanabilirsiniz
                    break;
                  case 2:
                  // Takvim sayfasını açmak için gerekli kodları buraya yazın
                  // Örneğin, Get.toNamed('/takvim') kullanabilirsiniz
                    break;
                  case 3:
                  // Email sayfasını açmak için gerekli kodları buraya yazın
                  // Örneğin, Get.toNamed('/email') kullanabilirsiniz
                    break;
                  case 4:
                  // Profil sayfasını açmak için gerekli kodları buraya yazın
                  // Örneğin, Get.toNamed('/profil') kullanabilirsiniz
                    break;
                  case 5:
                  // Ayarlar sayfasını açmak için gerekli kodları buraya yazın
                  // Örneğin, Get.toNamed('/ayarlar') kullanabilirsiniz
                    break;
                  default:
                    break;
                }
              },
            ),
            const Divider(thickness: 1),
            const SizedBox(height: kSpacing * 2),
            UpgradePremiumCard(
              backgroundColor: Theme.of(context).canvasColor.withOpacity(.4),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('MES TEKNOLOJİ TAKIMI'),
                    content: Text('Bizi Takip Edin'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Kapat'),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: kSpacing),
          ],
        ),
      ),
    );
  }
}
