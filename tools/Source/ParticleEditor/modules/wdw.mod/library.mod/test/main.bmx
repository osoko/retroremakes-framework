
'tests for library module

SuperStrict

Framework bah.maxunit

Import wdw.library

Include "libraryTest.bmx"
Include "readerTest.bmx"
Include "writerTest.bmx"

Include "mocks/testLibrary.bmx"
Include "mocks/testReader.bmx"
Include "mocks/testWriter.bmx"
Include "mocks/testObject.bmx"

New TTestSuite.run()
