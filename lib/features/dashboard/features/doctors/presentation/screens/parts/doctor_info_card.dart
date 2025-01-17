part of './../doctor_detailed_page.dart';

Container buildDoctorInfoCard(ColorScheme theme, DoctorModel doctor, double rating) {
  return Container(
    padding: EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: theme.primary.withOpacity(.1),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      children: [
        Center(
          child: Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              border: Border.all(color: theme.primary, width: 2),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: CachedNetworkImageProvider(doctor.imageUrl),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Doctor name
        Center(
          child: Text(
            doctor.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Doctor specialization
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: theme.primary,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              doctor.specialization,
              style: TextStyle(
                fontSize: 14,
                color: theme.onPrimary,
              ),
            ),
          ),
        ),

        const SizedBox(height: 15),

        // Doctor degrees
        Center(
          child: Column(
            spacing: 5,
            children: doctor.degrees
                .map((degree) => Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      "${degree.degree} from ${degree.institute} in ${degree.year}",
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.onSurface.withOpacity(.6),
                      ),
                    ))
                .toList(),
          ),
        ),

        const SizedBox(height: 10),

        // Doctor visiting fee
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Visiting Fee: ",
              style: TextStyle(
                fontSize: 16,
                color: theme.onSurface,
              ),
            ),
            Text(
              "BDT. ${doctor.visitingFee}",
              style: TextStyle(
                fontSize: 16,
                color: theme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // rating
        (rating != 0)
            ? Center(
                child: Row(
                  spacing: 5,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Display rating stars
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: buildRatingStars(
                          rating,
                          theme),
                    ),

                    Text(
                      '(${rating.toStringAsFixed(1)})',
                      style: TextStyle(fontSize: 16, color: theme.onSurface),
                    ),
                  ],
                ),
              )
            : Center(
                child: Row(
                  spacing: 5,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Display rating stars
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children:
                          buildRatingStars(double.parse(0.toString()), theme),
                    ),

                    Text(
                      '(No ratings yet)',
                      style: TextStyle(fontSize: 16, color: theme.onSurface),
                    ),
                  ],
                ),
              )
      ],
    ),
  );
}
