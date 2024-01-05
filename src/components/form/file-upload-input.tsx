"use client";
import {
  Input,
  FormControl,
  FormLabel,
  InputGroup,
  InputLeftElement,
  Icon,
} from "@chakra-ui/react";
import { FiFile } from "react-icons/fi";
import { useRef } from "react";
import useAWWStore from "@/store/AWWStore";

interface FileUploadInputProps {
  name: string;
  placeholder?: string;
  acceptedFileTypes?: string;
  noIcon?: boolean;
  children?: any;
  isRequired?: boolean;
  InterfaceComponent?: (props: any) => JSX.Element;
}

const FileUploadInput = ({
  noIcon,
  name,
  placeholder,
  acceptedFileTypes,
  children,
  InterfaceComponent,
}: FileUploadInputProps) => {
  const inputRef = useRef<HTMLInputElement>(null);
  const setFile = useAWWStore((state) => state.setFile);

  return (
    <FormControl>
      <FormLabel htmlFor="writeUpFile">{children}</FormLabel>
      <InputGroup>
        {!noIcon && (
          <InputLeftElement pointerEvents="none">
            <Icon as={FiFile} />
          </InputLeftElement>
        )}
        <input
          type="file"
          accept={acceptedFileTypes}
          onChange={(event) => {
            if (event.target.files)
              if (event.target.files.length > 0) {
                setFile(event.target.files[0]);
              }
          }}
          ref={inputRef}
          name={name}
          style={{ display: "none" }}
        ></input>
        {InterfaceComponent ? (
          <InterfaceComponent onClick={() => inputRef.current?.click()} />
        ) : (
          <Input
            placeholder={placeholder || "테라폼 파일을 업로드 해보세요 🙂"}
            onClick={() => inputRef.current?.click()}
            w="270px"
          />
        )}
      </InputGroup>
    </FormControl>
  );
};

export default FileUploadInput;
