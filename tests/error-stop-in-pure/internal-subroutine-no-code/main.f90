program main
  !! Check whether error stop is allowed inside a pure procedure
  implicit none

  integer file_unit

  open(newunit=file_unit, file="RESULT", status="REPLACE")
  write(file_unit,'(a)') "PASSED"

contains
  pure subroutine error_stop_in_pure()
    error stop
  end subroutine
end program
