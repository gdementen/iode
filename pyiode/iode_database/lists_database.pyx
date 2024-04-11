# distutils: language = c++

from collections.abc import Iterable
from typing import Union, Tuple, List, Optional, Any
if sys.version_info.minor >= 11:
    from typing import Self
else:
    Self = Any

cimport cython
from pyiode.iode_database.database cimport KDBLists as CKDBLists
from pyiode.iode_database.database cimport Lists as cpp_global_lists


@cython.final
cdef class Lists(_AbstractDatabase):
    cdef CKDBLists* database_ptr

    def __cinit__(self, filepath: str = None) -> Lists:
        """
        Get an instance of the IODE Lists database. 
        Load the IODE lists from 'filepath' if given.

        Parameters
        ----------
        filepath: str, optional
            file containing the IODE lists to load.

        Returns
        -------
        Lists

        Examples
        --------
        >>> from iode import Lists, SAMPLE_DATA_DIR
        >>> lst_db = Lists(f"{SAMPLE_DATA_DIR}/fun.lst")
        >>> len(lst_db)
        17
        """
        self.database_ptr = self.abstract_db_ptr = &cpp_global_lists
        if filepath is not None:
            self.load(filepath)

    def __dealloc__(self):
        # self.database_ptr points to the C++ global instance Lists 
        # which does not need to be manually deleted 
        pass

    # TODO: implement KDBAbstract::load() method (for global KDB only)
    def _load(self, filepath: str):
        cdef CKDBLists* kdb = new CKDBLists(filepath.encode())
        del kdb

    def subset(self, pattern: str, copy: bool = False) -> Lists:
        subset_ = Lists()
        subset_.database_ptr = subset_.abstract_db_ptr = self.database_ptr.subset(pattern.encode(), <bint>copy)
        return subset_

    def _get_object(self, key):
        if not isinstance(key, str):
            raise TypeError(f"Cannot get object {key}.\nExpected a string value for {key} " + 
                "but got value of type {type(filepath).__name__}")
        return self.database_ptr.get(key.encode()).decode()

    def _set_object(self, key, value):
        if not isinstance(key, str):
            raise TypeError(f"Cannot set object {key}.\nExpected a string value for {key} " + 
                "but got value of type {type(filepath).__name__}")
        if self.database_ptr.contains(key.encode()):
            self.database_ptr.update(key.encode(), value.encode())
        else:
            self.database_ptr.add(key.encode(), value.encode())
    
    def add(self, name: str, lst: str):
        if not isinstance(name, str):
            raise TypeError(f"'name': Expected value of type string. Got value of type {type(name).__name__}")
        self.database_ptr.add(name.encode(), lst.encode())

    def update(self, name: str, lst: str):
        if not isinstance(name, str):
            raise TypeError(f"'name': Expected value of type string. Got value of type {type(name).__name__}")
        self.database_ptr.update(name.encode(), lst.encode())