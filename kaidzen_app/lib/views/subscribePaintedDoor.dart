import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:kaidzen_app/assets/constants.dart';
import 'package:kaidzen_app/service/AnalyticsService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaidzen_app/views/subscribePaintedDoorOutro.dart';

import '../achievements/style.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  bool isYearlyPlan = true; 

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AchievementsStyle.achievementScreenBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.grey[600]),
            onPressed: () {
              FirebaseAnalytics.instance.logEvent(name: AnalyticsEventType.subscription_painted_door_declined.name);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      backgroundColor: AchievementsStyle.achievementScreenBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Say hello to your best self',
                style: Fonts.hugeTextStyleWhite,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 20),
              Text(
                'Members are up much more likely to reach their goals with Premium',
                style: Fonts.graySubtitle14,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 24),
              FireIconText(text: 'Unlimited goals in Do, Doing, Done'),
              FireIconText(text: 'Unlimited recurring goals'),
              SizedBox(height: 24),
              SubscriptionPlanSelector(
                onPlanChanged: (bool value) {
                  setState(() {
                    isYearlyPlan = value;
                  });
                },
              ),
              Expanded(child: Container()), // This will push the button to the bottom
              ElevatedButton(
                child: Text('Start 1-month free trial', style: Fonts.xLargeWhiteTextStyle),
                onPressed: () {
                  if (isYearlyPlan) {
                    FirebaseAnalytics.instance.logEvent(name: AnalyticsEventType.subscription_painted_door_accepted_option_year.name);
                  } else {
                    FirebaseAnalytics.instance.logEvent(name: AnalyticsEventType.subscription_painted_door_accepted_option_month.name);
                  }
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SubscriptionPageOutro()));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurpleAccent, // Adjusted to match the image
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FireIconText extends StatelessWidget {
  final String text;

  FireIconText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('🔥', style: Fonts.xLargeTextStyleWhite),
        SizedBox(width: 8),
        Text(text, style: Fonts.largeTextStyleWhite),
      ],
    );
  }
}

class SubscriptionPlanSelector extends StatefulWidget {
  final Function(bool) onPlanChanged;

  SubscriptionPlanSelector({required this.onPlanChanged});

  @override
  _SubscriptionPlanSelectorState createState() => _SubscriptionPlanSelectorState();
}

class _SubscriptionPlanSelectorState extends State<SubscriptionPlanSelector> {
  bool isYearlyPlan = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PlanOption(
          label: 'Yearly',
          text: 'Billed yearly after free trial',
          price: '\$41.94/year',
          originalPrice: '\$83.88/year',
          savings: '50% savings',
          isSelected: isYearlyPlan,
          onTap: () {
            setState(() {
              isYearlyPlan = true;
            });
            widget.onPlanChanged(isYearlyPlan);
          },
        ),
        SizedBox(width: 16),
        PlanOption(
          label: 'Monthly',
          text: 'Billed monthly after free trial',
          price: '\$6.99/month',
          originalPrice: '',
          isSelected: !isYearlyPlan,
          onTap: () {
            setState(() {
              isYearlyPlan = false;
            });
            widget.onPlanChanged(isYearlyPlan);
          },
        ),
      ],
    );
  }
}

class PlanOption extends StatelessWidget {
  final String label;
  final String text;
  final String price;
  final String? originalPrice;
  final String? savings;
  final bool isSelected;
  final VoidCallback onTap;

  const PlanOption({
    required this.label,
    required this.text,
    required this.price,
    this.originalPrice,
    this.savings,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Assuming a fixed height for the SavingsBadge or its placeholder.
    const double badgeHeight = 24.0; // Adjust the height as needed

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none, // Allows the badge to be positioned outside the container bounds.
          children: [
            Container(
              padding: const EdgeInsets.all(12.0).copyWith(top: 12.0 + badgeHeight / 2), // Adjust top padding to accommodate badge.
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
                border: Border.all(
                  color: isSelected ? Colors.deepPurpleAccent : Colors.white.withOpacity(0.3),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: badgeHeight / 2), // Placeholder space for the badge.
                  Text(label, style: Fonts.largeWhiteTextStyle),
                  SizedBox(height: 8),
                  Text(price, style: Fonts.xLargeTextStyleWhite),
                  if (originalPrice != null)
                    Text(originalPrice!, style: TextStyle(color: Colors.white.withOpacity(0.5), decoration: TextDecoration.lineThrough)),
                  SizedBox(height: 8),
                  Text(
                    this.text,
                    style: Fonts.graySubtitle14,
                  ),
                  SizedBox(height: 8),
                  Icon(isSelected ? Icons.check_circle : Icons.radio_button_unchecked, color: Colors.white, size: 24),
                ],
              ),
            ),
            if (savings != null && isSelected)
              Positioned(
                right: 0,
                top: -badgeHeight / 2, // Position the badge so half of it is outside the container.
                child: SavingsBadge(savings: savings!),
              ),
          ],
        ),
      ),
    );
  }
}

class SavingsBadge extends StatelessWidget {
  final String savings;

  const SavingsBadge({required this.savings});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: Text(
          savings,
          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
