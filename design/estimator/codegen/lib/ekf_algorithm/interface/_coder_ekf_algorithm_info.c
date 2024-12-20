/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_ekf_algorithm_info.c
 *
 * Code generation for function 'ekf_algorithm'
 *
 */

/* Include files */
#include "_coder_ekf_algorithm_info.h"
#include "emlrt.h"
#include "tmwtypes.h"

/* Function Declarations */
static const mxArray *c_emlrtMexFcnResolvedFunctionsI(void);

/* Function Definitions */
static const mxArray *c_emlrtMexFcnResolvedFunctionsI(void)
{
  const mxArray *nameCaptureInfo;
  const char_T *data[9] = {
      "789ced5acf73d240140e4ed51eac653c7870c619f5a2173b6db15abd4981065bb085e2d4"
      "8a4317b2942dc9866e127ef4d419673cda8b7f84478f1e1d4f1efc0f"
      "3c7af0a47f83852485acdde147629074df65797c61bfb76fc997c763855032151204e1aa"
      "60dabda839ce587ed81a2f084ea3f190355ea17cdb2e0a538ecfd9f8",
      "b1359654acc3a66e3a1828f0f49392aa200cb0bed5aa4181404d95eb50ea206524c32da4"
      "c06caf936e7b4aa2073a75da50fbf54a0596aa5943114845eb4628f7"
      "3aa7f9f8ca58efd480f99018f90853f8abf8eb9527f99c068996df8784b4f231b5816515"
      "485a5e438a21235cbd5f021890933724a8a13d9c879a8e14a0ab240f",
      "abe50290f75482f48a32a7841c7e016015274a78a1775dbb2ed77599b92e13515409ca85"
      "b2677c97987c2622a9465186ddf57d70c9b7c2e473e2a3ec5b273779"
      "2b43734a679e7e799a1d306e7aec5e3fdd19df66be87fce44bfe4edef293cfb671f13519"
      "f30dfabdbbcee00b53b85c2ba737728731421ec86978b81c69249a59",
      "b11bc7461f9e7e71080cdfaff927f5fe3d7219f78d3e71dbb8c97e60001d128c545c20aa"
      "7ef22c20c8fa028e4b773fb9e47bc1e473e26ef7edacccb5b7d22fdd"
      "78e3b30e7ffb797cd74f3edb82aec324dada69ecc49f3f6ac41a15b1995e7a68883b51ae"
      "c3e3d6e19acbb8e9df2974dc366eb2034424a003617cbafbd1255f92",
      "c9e7c4ddee9395296bb7825bf74edfaedff493cfb6a0eb6db6185d2f2e6131a326e7b78b"
      "87d5858354b218e37a3b6ebdf56bffffaade2448507d72ebdd0c93cf"
      "897b58ef7632660b7050ebdd2f9f79bddb36afefbfcda5acfa5286c51482894c4e8be616"
      "5663917870f4d76d1d9562cc1fa6704ffbbd8277fae7575f973656be",
      "6c9bf4e7e32e23ae49ad6f795fd734ded71d6efef3aeafd394df8ddf44f641492d2280bd"
      "ea63cc52be405d67e3650397f476755801583a2970bdd25bb10fbf8d"
      "bbdb2f3b6b734a50ebd95fd7def17a56f807fd84faf286b15eaaa5eaa234df909a6b70f3"
      "5939407a1bb4fbf77fab6347ed1bf03a96be9ed7b17ef0f13ad69bf9",
      "cf7b1d3b98be56b8bef6d1d74ac0f5f53dfa71c74f3edb82aeaf8bc6da5ee4a9188f1a2d"
      "b4286e47c588fc7895ff0f36f6fbf7c865dcfcfc178bcf89f3f35fc3"
      "f1f1f35fa6f1f35fc3cd3fa93aecb66f3a43f974dc36cecf7ff1f35f67f1f1f35fa6f1f3"
      "5fc3cdcffb0aacf8bded2bd0c6ca976d93fe3cdc65c435a9facafb0a",
      "a6f1bec270f3f3ffc3e8b879bf96eb2ad755aeaba3cdff07602e36bb",
      ""};
  nameCaptureInfo = NULL;
  emlrtNameCaptureMxArrayR2016a(&data[0], 16960U, &nameCaptureInfo);
  return nameCaptureInfo;
}

mxArray *emlrtMexFcnProperties(void)
{
  mxArray *xEntryPoints;
  mxArray *xInputs;
  mxArray *xResult;
  const char_T *propFieldName[9] = {"Version",
                                    "ResolvedFunctions",
                                    "Checksum",
                                    "EntryPoints",
                                    "CoverageInfo",
                                    "IsPolymorphic",
                                    "PropertyList",
                                    "UUID",
                                    "ClassEntryPointIsHandle"};
  const char_T *epFieldName[8] = {
      "QualifiedName",    "NumberOfInputs", "NumberOfOutputs", "ConstantInputs",
      "ResolvedFilePath", "TimeStamp",      "Constructor",     "Visible"};
  xEntryPoints =
      emlrtCreateStructMatrix(1, 1, 8, (const char_T **)&epFieldName[0]);
  xInputs = emlrtCreateLogicalMatrix(1, 9);
  emlrtSetField(xEntryPoints, 0, "QualifiedName",
                emlrtMxCreateString("ekf_algorithm"));
  emlrtSetField(xEntryPoints, 0, "NumberOfInputs",
                emlrtMxCreateDoubleScalar(9.0));
  emlrtSetField(xEntryPoints, 0, "NumberOfOutputs",
                emlrtMxCreateDoubleScalar(2.0));
  emlrtSetField(xEntryPoints, 0, "ConstantInputs", xInputs);
  emlrtSetField(
      xEntryPoints, 0, "ResolvedFilePath",
      emlrtMxCreateString("C:\\Users\\jerry\\Downloads\\simulink-"
                          "canards\\design\\estimator\\ekf_algorithm.m"));
  emlrtSetField(xEntryPoints, 0, "TimeStamp",
                emlrtMxCreateDoubleScalar(739605.80729166663));
  emlrtSetField(xEntryPoints, 0, "Constructor",
                emlrtMxCreateLogicalScalar(false));
  emlrtSetField(xEntryPoints, 0, "Visible", emlrtMxCreateLogicalScalar(true));
  xResult =
      emlrtCreateStructMatrix(1, 1, 9, (const char_T **)&propFieldName[0]);
  emlrtSetField(xResult, 0, "Version",
                emlrtMxCreateString("24.2.0.2773142 (R2024b) Update 2"));
  emlrtSetField(xResult, 0, "ResolvedFunctions",
                (mxArray *)c_emlrtMexFcnResolvedFunctionsI());
  emlrtSetField(xResult, 0, "Checksum",
                emlrtMxCreateString("T5tgNij75lqm3vO7bTyaU"));
  emlrtSetField(xResult, 0, "EntryPoints", xEntryPoints);
  return xResult;
}

/* End of code generation (_coder_ekf_algorithm_info.c) */
