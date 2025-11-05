import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.graphics.BitmapFactory
import android.widget.RemoteViews
import com.example.tiffin.R // <-- import your app's R file
import es.antonborri.home_widget.HomeWidgetProvider

/**
 * Implementation of App Widget functionality.
 */
class CustomHomeView : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
                val imageName = widgetData.getString("filename", null)
                setImageViewBitmap(
                    R.id.widget_image,
                    BitmapFactory.decodeFile(imageName)
                )
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}