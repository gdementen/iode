#include "scalars_view.h"


void ScalarsView::new_obj()
{
	QIodeAddScalar dialog(*project_settings_filepath, this);
	dialog.exec();
	filter_and_update();
}
