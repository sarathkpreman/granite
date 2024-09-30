import React, { useState } from "react";

import authApi from "apis/auth";
import SignupForm from "components/Authentication/Form/Signup";

const Signup = ({ history }) => {
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [passwordConfirmation, setPasswordConfirmation] = useState("");
  const [loading, setLoading] = useState(false);

  const handleSubmit = async event => {
    event.preventDefault();
    setLoading(true);
    try {
      await authApi.signup({
        name,
        email,
        password,
        password_confirmation: passwordConfirmation,
      });
      setLoading(false);
      history.push("/dashboard");
    } catch (error) {
      logger.error(error);
      setLoading(false);
    }
  };

  return (
    <SignupForm
      email={email}
      handleSubmit={handleSubmit}
      loading={loading}
      name={name}
      password={password}
      passwordConfirmation={passwordConfirmation}
      setEmail={setEmail}
      setName={setName}
      setPassword={setPassword}
      setPasswordConfirmation={setPasswordConfirmation}
    />
  );
};

export default Signup;
