#include "comments_view.h"


void CommentsView::new_comment()
{
	QIodeAddComment dialog(this);
	dialog.exec();
	update();
}
