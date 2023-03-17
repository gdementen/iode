#include "scalars_view.h"


void ScalarsView::new_obj()
{
	QIodeAddScalar dialog(*project_settings_filepath, this);
	if(dialog.exec() == QDialog::Accepted)
		emit newObjectInserted();
	filter_and_update();
}
