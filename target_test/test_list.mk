# ----------------------------------------------------------------------------------------
# To add a test, just call the TEST_DEFINITION macro with the names of the files
# that are used by the test. The general format is:
#
#$(eval $(call TEST_DEFINITION,<test_file>,<files_to_test>))
#                               ^           ^
#                               |           |               +-- This part is optional#                               |           +------------------ Files to be tested, also optional
#                               +------------------------------ A single file w. unit tests
#
# Note 1: The name of the executable will be the same as the name of the test file minus
#         the .c extension. So if the unit test file is called test1.c, the executable will
#		  be called test1
#
# Note 2: If there are more than two files to be tested or mocked they are separated
#         by SPACES, NOT commas.
#
# Note 3: There must always be a single test file, but there can be zero or more files to
#         be tested or mocked. If there are no files to be tested or mocked, the corresponding
#         argument must be an empty string (absent). Just remember to leave the commas in so
#         that there's always 3 arguments to the TEST_DEFINITION macro (see examples below).
#
# Examples:
#$(eval $(call TEST_DEFINITION, test1.c,,))                   // No files to test
#$(eval $(call TEST_DEFINITION, test2.c, funcuser.c func.c,)) // Two files to test
#
# ----------------------------------------------------------------------------------------


# ================== Define all tests BELOW this line ==================

$(eval $(call TEST_DEFINITION, test_add_op.c, add_op.c))
$(eval $(call TEST_DEFINITION, test_mul_op.c, mul_op.c))
$(eval $(call TEST_DEFINITION, test_fff.c, calculator.c mul_op.c div_op.c sub_op.c))

# ================== Define all tests ABOVE this line ==================
