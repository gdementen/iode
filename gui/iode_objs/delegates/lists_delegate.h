#pragma once

#include "text_delegate.h"


class ListsDelegate : public TextDelegate
{
	Q_OBJECT

public:
	ListsDelegate(QObject* parent = nullptr) : TextDelegate(I_UPPER, parent) {}

	~ListsDelegate() {}
};