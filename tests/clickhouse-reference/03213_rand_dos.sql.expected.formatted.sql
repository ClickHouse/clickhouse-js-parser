SELECT randChiSquared(-1e-7); -- { serverError BAD_ARGUMENTS }

SELECT randChiSquared(-0.); -- { serverError BAD_ARGUMENTS }

SELECT randStudentT(-0.); -- { serverError BAD_ARGUMENTS }

SELECT randFisherF(-0., 1); -- { serverError BAD_ARGUMENTS }

SELECT randFisherF(1, -0.); -- { serverError BAD_ARGUMENTS }