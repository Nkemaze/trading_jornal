enum AlertType { priceAlert, reminder }

class AlertItem {
  final String id;
  final String title;
  final String subtitle;
  final AlertType type;
  final bool isActive;
  final String? leadingIcon;
  final String? leftBorderColor;

  const AlertItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    this.isActive = true,
    this.leadingIcon,
    this.leftBorderColor,
  });

  AlertItem copyWith({bool? isActive}) {
    return AlertItem(
      id: id,
      title: title,
      subtitle: subtitle,
      type: type,
      isActive: isActive ?? this.isActive,
      leadingIcon: leadingIcon,
      leftBorderColor: leftBorderColor,
    );
  }

  static final sampleData = [
    const AlertItem(
      id: '1',
      title: 'BTC/USD above \$65,000',
      subtitle: 'Created 2 days ago',
      type: AlertType.priceAlert,
      isActive: true,
      leadingIcon: 'trending_up',
    ),
    const AlertItem(
      id: '2',
      title: 'Market Close Review',
      subtitle: '4:00 PM Daily',
      type: AlertType.reminder,
      isActive: true,
      leadingIcon: 'update',
      leftBorderColor: '#53e16f',
    ),
  ];
}
